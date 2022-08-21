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

wlc1_credentials = {
    'ip': "x.x.x.x",
    'device_type': "",
    'username': "-",
    'password': "-"}
# Formato de las credenciales necesarias para la conexion con el wireless lan controller 

try:
    connection1 = nk.ConnectHandler(**wlc1_credentials)
    print("*********WLC1**********")
    # section show ap summary

    ap_client = connection1.send_command("show client summary username")
    # Se obtiene la MAC y username de clientes y se almacena en ap_cliente
    
    macs = []  # Lista de direcciones MAC de los clientes
    client_list = ap_client.splitlines()[5::1]
     # Se particiona la informacion de show client summary name y se crea una lista 

    for i in client_list:
        client_data = i.split()
        # and ("N/A" not in client_data[3])) or ((client_data[1] == "Domo_Teleco1") and ("N/A" not in client_data[3])):
        if (client_data[1] == "Domo_Teleco2") or (client_data[1] == "Domo_Teleco1"):
            macs.append(client_data[0])
    
    #Se recorre la lista client_list y por cada elemento se realiza un split y se verifica si son Domo_Teleco2 o 1 para filtrar
    #cuales MACS estan bajo estos APs que tienen solapamiento 
    print(macs)

    # section show client detail MAC
    usmac = []
    usernames = []
    apnames = []
    rssis = []
    nearrssi = []
    ssid = []
    nearAP = []
    distancia = []
    prompt = connection1.find_prompt()
    #Listas a ser llenadas con info recopilada por cada dispositivo conectado en los AP que se solapan 

    for m in macs:
        command = "show client detail " + m
        print(command)
        connection1.write_channel(f"{command}\n")
        time.sleep(0.075)
        # Se recorren las macs que estan en el area de solapamiento y por cada una se ejecuta el comando show client detail

        output = ""
        page = ""
        i = 0
        while True:
            try:
                if(i < 7):
                    page = connection1.read_until_pattern(f"More|{prompt}")
                    # print(page)
                else:
                    page = connection1.read_until_pattern(
                        f"More|{prompt}|\n|\t|\s")

                    # print(page)
                if "More" in page:
                    output += page
                    connection1.write_channel(" ")
                    time.sleep(0.075)
                elif prompt in page:
                    output += page
                    print("****Command Out*****")
                    break
                i += 1
            except NetmikoTimeoutException:
                print("****EXCEPTION*****")
                break
        #Se esta leyendo a traves de la conexion con show client detail 7 veces , al final verifica si hay mas info que mostrar
        # y envia al canal " " para que se siga mostrando, vuelve a leer y todo finalmente se almacena en output
        out_data = output.splitlines()[1::1]
        #Se da formato a lo que se tiene en output particionando para luego recorrer 
        username = ""
        apname = ""
        ssi = ""
        rssi = ""
        tiempo = ""

        valor_rssi = []  # Valor RSSI vecinos
        near_name = []  # nombre vecinos

        for o in out_data:
            item = o.split()
            if((len(item) == 4) and ("Username" in item[1])): # Nombre de Usuario
                usernames.append(item[3])
                username = item[3]
            if((len(item) == 3) and ("Name" in item[1])):  # Nombre del Ap
                apnames.append(item[2])
                apname = item[2]
            if((len(item) == 6) and ("SSID" in item[4])):  # SSID
                ssid.append(item[5])
                ssi = item[5]
            if((len(item) == 6) and ("Indicator" in item[3])):  # RSSI
                rssis.append(item[4])
                rssi = int(item[4])
            # Nombre de Aps vecinos
            # Nombre de Aps vecino directo DOMO TELECO 1 o DOMO TELECO 2
            if((len(item) == 2) and ("0)" in item[1])):
                np = item[0][0:-5]
                #print("AA", np)
                if(np != apname and np != "Direccion" and np != "Admin_Tec"):
                    near_name.append(np)
            # RSSI de Ap vecinos
            # RSSI de Ap vecinos (En este caso vecino directo DOMO TELECO1 o DOMO TELECO 2)
            if((len(item) == 6) and ("antenna0:" in item[0])) and ((len(near_name) == 1)):
                vr = int(item[4])
                valor_rssi.append(vr)
                if(len(valor_rssi) > 1):
                    # print("SSSS")
                    # print(vr)
                    valor_rssi.pop(1)
        nearAP.append(near_name)
        nearrssi.append(valor_rssi)
        now = datetime.now()
        timestamp = datetime.timestamp(now)

        datos = {
            "MAC": m,
            "date": timestamp,
            "Username": username,
            "apName": apname,
            "SSID": ssi,
            "RSSI": rssi,
            # "rssi_ap": listNR,
            "nearNameAP": near_name[0],
            "nearRSSIAP": valor_rssi[0]
        }

        print(datos)

        doc_ref = db.collection('data_network').document(m)
        doc = doc_ref.get()
        #Se guarda en la coleccion data_network la mac que esta siendo recorrida luego se trae la referencia de esto almacenado en la base de datos
        #a la variable doc
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
