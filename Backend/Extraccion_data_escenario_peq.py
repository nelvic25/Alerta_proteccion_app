import netmiko as nk
from netmiko import ConnectHandler, NetmikoTimeoutException
import time
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from numpy.lib.type_check import real
import math
from sympy import var, solve
from datetime import datetime

# Use a service account
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

#mainAp_credentials pasaria a ser el router principal del daisy chain


mainAp_credentials = {
    'ip': "192.168.1.1",
    'device_type': "autodetect",
    'username': "root",
    'password': "admin"}
# Formato de las credenciales necesarias para la conexion con el wireless lan controller 

try:
    connection1 = nk.ConnectHandler(**mainAp_credentials)
    Ap_data = connection1.send_command("iwinfo wl0 info")
    Ap_data_splitline = Ap_data.splitlines()[1:2:1]
    Ap_data_list=Ap_data_splitline[0].split()
    Ap_macaddress=Ap_data_list[-1]
    #Se obtiene la MAC Address el router de la victima
    clientes_Conectados=[]
    Ap_data = connection1.send_command("iwinfo wl0 assoc")
    Ap_data_splitline = Ap_data.splitlines()
    for clientes in Ap_data_splitline:
        clientes_Conectados.append(clientes.split()[0])
    #Se obtiene las MAC Address de los clientes conectados al router

        now = datetime.now()
        timestamp = datetime.timestamp(now)


        #Crear diccionario asociando lista de valores de RSSI para una mac 

        datos = {
            "MAC": m,
            "date": timestamp,
            #"Username": username,
            #"apName": apname,
            #"apIp": ip,
            "RSSIs": rssis_pormac,
        }
        print(datos)
        #POR CADA MAC DE DISPOSITIVO CLIENTE TENDRE UN REGISTRO DE RSSI POR CADA Ap

        #CONTINUAR MODIFICANDO DE AQUI 
        doc_ref = db.collection('data_devices').document(Ap_macaddress)
        doc = doc_ref.get()
        #Se realiza la accion document en la coleccion 'COLECCION...' la mac que esta siendo recorrida luego se trae la referencia de esto a la variable doc
        datosN = {
            "last_update": timestamp,
            "data": [datos]
        }
        #Se crea el diccionario datosN con la data obtenida de la mac siendo recorrida y la ultima fecha de actualizaciin last_update

        if doc.exists:
            newDatosN = doc.to_dict().copy()
            # print(datetime.fromtimestamp(newDatosN['last_update']))
            newDatosN['last_update'] = timestamp
            newDatosN["data"].append(datos)
            # print(newDatosN)
            doc_ref.set(newDatosN)
        else:
            # print(datosN)
            doc_ref.set(datosN)

        #Se manda a almacenar en la base de datos de firestore los diccionarios newDatosN o datosN dependiendo de si existe el doc de la coleccion


        # Modelo Matemático de canal PATH LOSS
        # RSSI=-10nlog(d/d0)+RSSI0 - 15

        rssi0 = -14  # Valor promedio de RSSI a una distancia d0/ d0=1
        n = 4  # Factor de atenuación en interiores
        rssiT1 = (rssi0-rssi-15)/(10*n)
        d1 = 10**(rssiT1)
        rssiT2 = (rssi0-(valor_rssi[0])-15)/(10*n)
        d2 = 10**(rssiT2)

        # Trilateración Mínimos Cuadrados con solo dos Access Points
        # (xi-x)^2 + (yi-y)^2 = d^2
        x1 = 0
        x2 = 0
        y1 = -7.35
        y2 = 7.35

        x, y = var('x y')

        f1 = (x-x1)**2 + (y-y1)**2 - d1**2
        f2 = (x-x2)**2 + (y-y2)**2 - d2**2

        sols = solve((f1, f2), (x, y))
        print(sols)

        if(("I" in str(sols[1][0])) or ("I" in str(sols[1][0]))):
            cx = str(sols[1][0])[0:-2]
            cx= float(cx)
            cy = float(sols[1][1])
            coorx = round(cx, 2)
            coory = round(cy, 2)  
            print(cx)
        else: 
            cx = float(sols[1][0])
            cy = float(sols[1][1])
            coorx = round(cx, 2)
            coory = round(cy, 2)        
        tuplausmacs = (m, username)
        usmac.append(tuplausmacs)
        tuplaxy = (coorx, coory)
        distancia.append(tuplaxy)

        datos2 = {
            "MAC": m,
            "Username": username,
            "coorx": coorx,
            "coory": coory,

        }

        doc_ref1 = db.collection('user_position').document(m)
        doc_ref1.set(datos2)
        #Se calcula,agrupa la informacion por MAC  y las coordenadas de donde este se encuentre para luego poder almacenar en
        #la coleccion user_position.
except Exception as e:
    print(e)
now = datetime.now()
timestamp = datetime.timestamp(now)

# Distancia euclidiana entre puntos (distancia entre cada usuario)
historyarr=[]
dis_obj =[]
k = 0
for i in range(len(distancia)):
    for j in range(0, len(distancia)):
        cumple = True
        print("distancia entre " + usernames[i]+" y "+usernames[j])
        dis = math.dist(distancia[i], distancia[j])
        dis = round(dis, 2)
        print(dis)
        if(dis < 2 and dis!=0):
            cumple = False
            history={
                'date': now,
                'distance':dis,
                'cumple': cumple,
                'mac': macs[j],
                'username': usernames[j]
            }
            doc_ref3 = db.collection('history_distance_prueba').document(macs[i])
            doc3 = doc_ref3.get()
            history_N = {
                'mac' : macs[i],
                'username':usernames[i],
                'last_update': now, 
                'history':[history]
            }
            if doc3.exists:
                newHistoryN = doc3.to_dict().copy()
                newHistoryN['last_update'] = now
                newHistoryN['history'].append(history)
                print(newHistoryN)
                doc_ref3.set(newHistoryN)
            else:
                print(history_N)
                doc_ref3.set(history_N)
        obj = {
            'mac': macs[j],
            'username': usernames[j],
            'distancia': dis,
            'cumple': cumple,
            'time': timestamp

        }
        dis_obj.append(obj)
        if(i == j):
            dis_obj.pop(j)
        if(j == len(distancia)-1):
            print("ENTROOO")
            doc_ref2 = db.collection('user_position').document(macs[i])
            doc2 = doc_ref2.get()
            nearby = {'nearby': dis_obj}
            if (doc2.exists):
                doc_ref2.update(nearby)
            else:
                doc_ref2.set(nearby)
            del dis_obj[0:len(distancia)]
