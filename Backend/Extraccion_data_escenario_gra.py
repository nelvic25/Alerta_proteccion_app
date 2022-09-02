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
    'ip': "192.168.1.1", #CHEQUEAR ESTO 
    'device_type': "autodetect",
    'username': "root",
    'password': "root"}
# Formato de las credenciales necesarias para la conexion con el Ap de la casa

try:
    connection1 = nk.ConnectHandler(**Ap_credentials)
    Ap_data = connection1.send_command("iwinfo wl0 info")
    Ap_data_splitline = Ap_data.splitlines()[1:2:1]
    Ap_data_splitline2 = Ap_data.splitlines()[:1:1] #PARA SACAR EL NOMBRE DEL ACCESS POINT
    Ap_data_list=Ap_data_splitline[0].split()
    Ap_data_list2=Ap_data_splitline2[0].split()
    Ap_macaddress=Ap_data_list[-1]

    AP_name=Ap_data_list2[-1]
    #Se obtiene la MAC Address del router de la victima

    clientes_Conectados=[]

    Ap_data = connection1.send_command("iwinfo wl0 assoc")
    Ap_data_splitline = Ap_data.splitlines()
    for clientes in Ap_data_splitline:
        clientes_Conectados.append(clientes.split()[0])
    #Se obtiene las MAC Address de los clientes conectados al router
    print(clientes_Conectados)

    doc_ref1 = db.collection('mac_attackers').document(Ap_macaddress)
    doc = doc_ref1.get()
    doc_coleccion=doc.to_dict()
    n=1
    for conectado in clientes_Conectados:
        lista_atacantes=doc.coleccion.get("attackers")
        for atacante in lista_atacantes :
            if conectado==atacante:
                nombreDocumento = "Alerta " + n
                now = datetime.now()
                timestamp = datetime.timestamp(now)
                datos = {
                    "mac_agresor": atacante,
                    "mac_victima":conectado,
                    "fecha": timestamp
                }
                print(datos)
                #doc_ref2 = db.collection('alerts').document(nombreDocumento).set(datos,merge=True)
                n=n+1
                #Almacena en la base de datos de alertas 

                registration_token = doc_coleccion.get("token")
                
                message = messaging.Message(
                    notification = messaging.Notification(
                        title='ALERTA',
                        body='PRUEBAs'
                    )
                    data={
                        'time': timestamp,
                    },
                    token=registration_token
                )
                response = messaging.send(message)
                print('Successfully sent message:', response)  
except Exception as e:
    print(e)
    now = datetime.now()
    timestamp = datetime.timestamp(now)
       
                
""" 
        # Modelo Matemático de canal PATH LOSS
        # RSSI=-10nlog(d/d0)+RSSI0 - 15

        rssi0 = -14  # Valor promedio de RSSI a una distancia d0/ d0=1
        n = 4  # Factor de atenuación en interiores
        rssiT1 = (rssi0-rssi-15)/(10*n)
        d1 = 10**(rssiT1)
        rssiT2 = (rssi0-(valor_rssi[0])-15)/(10*n)
        d2 = 10**(rssiT2)
        #rssiT3 = (rssi0-(valor_rssi[1])-15)/(10*n)
        #d2 = 10**(rssiT2)

        # Trilateración Mínimos Cuadrados con solo dos Access Points
        # (xi-x)^2 + (yi-y)^2 = d^2
        x1 = 0
        x2 = 0
        #x3 = 0
        y1 = -7.35
        y2 = 7.35
        #y3 = 0
        #COORDENADAS DE LOS AP CONOCIDOS

        x, y = var('x y')
        #x, y , z= var('x y z')

        f1 = (x-x1)**2 + (y-y1)**2 - d1**2
        f2 = (x-x2)**2 + (y-y2)**2 - d2**2
        #f3 = (x-x3)**2 + (y-y3)**2 - d3**2

        sols = solve((f1, f2 ), (x, y))
        #sols = solve((f1, f2 , f3), (x, y ,z))
        print(sols)

        if(("I" in str(sols[1][0])) or ("I" in str(sols[1][1]))):
            cx = str(sols[1][0])[0:-2]
            cx= float(cx)
            cy = float(sols[1][1])
            coorx = round(cx, 2)
            coory = round(cy, 2)
            print(cx)
        else: 
            cx = float(sols[1][0])
            cy = float(sols[1][1])
            cz = float(sols[1][2])
            coorx = round(cx, 2)
            coory = round(cy, 2)

        datos2={
            "AP_name": AP_name,
            "PosicionX": coorx,
            "PosicionY": coory,
        }
        doc_ref2 = db.collection('global_alerts').document(X) #X ES MAC ADDRESS VERIFICAR DE DONDE SALE , COMO FUNCIONA EL SISTEMA
        doc_ref2.set(datos2,merge=True)
 """

