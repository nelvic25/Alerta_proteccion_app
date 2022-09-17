from heapq import merge
from turtle import title
import netmiko as nk
from netmiko import ConnectHandler, NetmikoTimeoutException
import time
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from firebase_admin import messaging
from numpy.lib.type_check import real
import math
from sympy import var, solve
from datetime import datetime
import os 

cred = credentials.Certificate('key.json')
firebase_admin.initialize_app(cred)           
db = firestore.client()
#Se hace uso de las librerias firebase_admin que en conjunto con la data que esta en key.json
#permite conectarse a las distintas funciones (firebase functions) que nos provee firebase

def delete_collection(coll_ref, batch_size):
    docs = coll_ref.limit(batch_size).stream()
    deleted = 0
    for doc in docs:
        #print(f'Deleting doc {doc.id} => {doc.to_dict()}')
        doc.reference.delete()
        deleted = deleted + 1

    if deleted >= batch_size:
        return delete_collection(coll_ref, batch_size)
#Borra colecciones

Ap_credentials = {
    'ip': "", 
    'device_type': "autodetect",
    'username': "root",
    'password': "root"}
# Formato de las credenciales necesarias para la conexion con el Ap de la casa

listaIp_peq=[]
listaIp_gra=[]
malasIp=[]
cont='Y'
verifica_Clientes_Conectados= lambda c_Conectados,ap_nombre : "No hay dispositivos conectados en la red "+ap_nombre if c_Conectados[0]=='No' else "Los siguientes dispositivos se encuentran conectados en la red: " +ap_nombre +' '+ str(c_Conectados) 

print('Registre los Dispositivos de red : ')
while(cont=='Y' or cont=='y'):
    print('1.- Infraestructura de cobertura peq/med ')
    print('2.- Infraestructura de cobertura grande ')
    op=input()
    if op=='1':
        print('Ingrese la ip : ')
        var=input()
        listaIp_peq.append(var)
    elif op=='2' :
        print('Ingrese la ip : ')
        var=input()
        listaIp_gra.append(var)
    else:
        print('Opcion incorrecta, no se ingresaron datos ')

    print('Continuar registrando ? Y/N')
    cont=input()
    os.system('cls')
os.system('cls')
print ('######### MONITOREO ACTIVO #########')
while(True):
    lista_victimas_globales=[]
    docs_global_alerts_ref=db.collection('global_alerts').stream()
    for doc in docs_global_alerts_ref:   
        lista_victimas_globales.append(doc.id)

    for ip in listaIp_peq:
        Ap_credentials["ip"]=ip
        try:
            connection1 = nk.ConnectHandler(**Ap_credentials)
            Ap_data = connection1.send_command("iwinfo wl0 info")
            Ap_data_splitline = Ap_data.splitlines()[1:2:1]
            Ap_data_splitline2 = Ap_data.splitlines()[:1:1] #PARA SACAR EL NOMBRE DEL ACCESS POINT
            Ap_data_list=Ap_data_splitline[0].split()
            Ap_data_list2=Ap_data_splitline2[0].split()
            Ap_macaddress=Ap_data_list[-1]
            AP_name=Ap_data_list2[-1]
            #Se obtiene la MAC Address del router de la victima y el Nombre del access point

            clientes_Conectados=[]
            Ap_data = connection1.send_command("iwinfo wl0 assoc")
            Ap_data_splitline = Ap_data.splitlines()
            for clientes in Ap_data_splitline:
                clientes_Conectados.append(clientes.split()[0])
            #Se obtiene las MAC Address de los clientes conectados al router
            print("Se esta monitoreando el router con MAC Address "+Ap_macaddress + ' : '+ verifica_Clientes_Conectados(clientes_Conectados,AP_name))
            #if(clientes_Conectados[0]=='No'):
            #    print("No hay dispositivos conectados en la red "+ AP_name)
            #else:
            #    print("Los siguientes dispositivos se encuentran conectados en la red: "+ AP_name)
            #    print(clientes_Conectados)

            doc_Ap_macaddress_ref = db.collection('mac_attackers').document(Ap_macaddress)
            doc__Ap_macaddress_dataframe = doc_Ap_macaddress_ref.get()
            doc_coleccion=doc__Ap_macaddress_dataframe.to_dict()
            for conectado in clientes_Conectados:
                lista_atacantes=doc_coleccion.get("attackers")
                for atacante in lista_atacantes :
                    if conectado==atacante:
                        print("ATACANTE DETECTADO !!! Se detecto la conexion del dispositivo registrado como atacante "+ conectado + " en la red Wi-Fi "+AP_name+ " del router con MAC ADDRESS " +Ap_macaddress)
                        registration_token = doc_coleccion.get("token")
                        now = datetime.now()
                        datos = {
                            "mac_agresor": atacante,
                            "mac_victima":Ap_macaddress,
                            "fecha": now,
                            "token": registration_token
                        }
                        #doc_ref2 = db.collection('alerts').document().set(datos)
                        db.collection('alerts').document().set(datos)
                        #Almacena en la base de datos de alertas 

                        message = messaging.Message(
                            notification = messaging.Notification(
                                title='ALERTA!!! ',
                                body='El atacante '+atacante+ ' ha ingresado al perimetro.'
                            ),
                            data={
                                'time': 'DATA'
                            },
                            token=registration_token
                        )
                        response = messaging.send(message)
                        #print('Se envia exitosamente la notificacion a la victima :', response)
                        print('Se envia exitosamente la notificacion a la victima : '+str(datos))

            clientes_Conectados=[]
            time.sleep(5)
        except Exception as e:
            print('Error al tratar de realizar la conexion con Ip : '+ ip +' Infraestructura pequenia/mediana cobertura.')
            print('Eliminando registro '+ ip + ' ...')
            #listaIp_peq.remove(ip)
            malasIp.append(ip)
            #print (e)
            time.sleep(2)
       
    for victima in lista_victimas_globales:
        lista_valores_rss=[]
        for ip in listaIp_gra:
            Ap_credentials["ip"]=ip
            try:
                connection1 = nk.ConnectHandler(**Ap_credentials)
                Ap_data = connection1.send_command("horst")
                lista_dispositivos = Ap_data.splitlines()
                for cada_dispositivo in lista_dispositivos:
                    if victima in cada_dispositivo:
                        lista_valores_rss.append(cada_dispositivo.split()[2])

                time.sleep(3)
            except Exception as e:
                print('Error al tratar de realizar la conexion con el Ip : '+ ip +' Infraestructura gran cobertura.')
                print('Eliminando registro '+ ip + ' ...')
                #listaIp_gra.remove(ip)
                malasIp.append(ip)
                time.sleep(2)

        for ip in malasIp:
            if ip in listaIp_gra :
                listaIp_gra.remove(ip)
            elif ip in listaIp_peq : 
                listaIp_peq.remove(ip)

        print(victima+" Esta solicitando ayuda. Posicionando... ")

        # Modelo Matemático de canal PATH LOSS RSSI=-10nlog(d/d0)+RSSI0 - 15
        # rssi0 = -14  # Valor promedio de RSSI a una distancia d0/ d0=1
        # n = 4  # Factor de atenuación en interiores

        # rssiT1 = (rssi0-lista_valores_rss[0]-15)/(10*n)
        # d1 = 10**(rssiT1)
        # rssiT2 = (rssi0-(lista_valores_rss[1])-15)/(10*n)
        # d2 = 10**(rssiT2)
        # #rssiT3 = (rssi0-(lista_valores_rss[2])-15)/(10*n)
        # #d3= 10**(rssiT3)

        # #COORDENADAS DE LOS AP CONOCIDOS
        # x1 = 0
        # x2 = 0
        # #x3 = 7.35
        # y1 = -7.35
        # y2 = 7.35
        # #y3 = 0

        # x, y = var('x y')
        # #x, y , z= var('x y z')


        # # Trilateración Mínimos Cuadrados con solo dos Access Points :  (xi-x)^2 + (yi-y)^2 = d^2

        # f1 = (x-x1)**2 + (y-y1)**2 - d1**2
        # f2 = (x-x2)**2 + (y-y2)**2 - d2**2
        # f3 = (x-x3)**2 + (y-y3)**2 - d3**2

        # sols = solve((f1, f2, f3), (x, y))
        # print(sols)

        # if(("I" in str(sols[1][0])) or ("I" in str(sols[1][1]))):
        #     cx = str(sols[1][0])[0:-2]
        #     cx= float(cx)
        #     cy = float(sols[1][1])
        #     coorx = round(cx, 2)
        #     coory = round(cy, 2)
        #     print(cx)
        # else: 
        #     cx = float(sols[1][0])
        #     cy = float(sols[1][1])
        #     coorx = round(cx, 2)
        #     coory = round(cy, 2)


        datos2={
            "PosicionX": 'coorx',
            "PosicionY": 'coory',
        }
        db.collection('global_alerts').document(victima).set(datos2,merge=True)#SE ESTA ACTUALIZANDO LA POSICION CONSTANTEMENTE DE CADA DISPOSITIVO QUE ESTA PIDIENDO SOCORRO EN LA COLECCION GLOBAL ALERTS

        

       

