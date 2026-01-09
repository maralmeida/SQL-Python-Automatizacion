import pyodbc
import json
from datetime import datetime

# 1. Configuración: Cambia lo que está entre comillas por los datos de tu server de bd y credenciales del usuario de acceso a la base
config = {
    'server': '127.0.0.1, 1433',        # O la IP de tu server
    'database': 'UsuariosApp',
    'user': 'usuario_php',                 # Tu usuario de acceso a la base
    'password': 'usuario_php'
}

# 2. Cadena de conexión
conn_str = (
    f"DRIVER={{ODBC Driver 17 for SQL Server}};"  #validar driver en windows - origenes de datos ODBC 64 bits - drivers
    f"SERVER={config['server']};"
    f"DATABASE={config['database']};"
    f"UID={config['user']};"
    f"PWD={config['password']};"
)

try:
    # 3. Conectar
    print("Conectando a la base de datos...")
    conexion = pyodbc.connect(conn_str)
    cursor = conexion.cursor()

    # 4. Escribir y ejecutar la consulta
    query = "SELECT TOP 5 * FROM registros" # Cambia 'registros' por una tu tabla
    cursor.execute(query)

    # 5. Obtener y mostrar resultados
    columnas = [column[0] for column in cursor.description]  #obtiene nombres de columnas
    print(f"\nColumnas: {columnas}")                         #muestra nombres de columnas
    print("-" * 50)

    resultados = []

    for fila in cursor.fetchall():
        print(fila)

        resultados.append(dict(zip(columnas, [str(v) for v in fila]))) # Cre diccionario uniendo nombres de columnas con valores,  str(valor) por si hay fechas o tipos de datos raros
     
        
    # 4. Guardar en archivo JSON
    nombre_archivo = f"export_db_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
    
    with open(nombre_archivo, 'w', encoding='utf-8') as f:
        json.dump(resultados, f, ensure_ascii=False, indent=4)

    print(f"✅ Éxito. Se generó el archivo: {nombre_archivo}")

except Exception as e:
    print(f"Error: {e}")

finally:
    # 6. Cerrar conexión
    if 'conexion' in locals():
        conexion.close()
        print("\nConexión cerrada.")