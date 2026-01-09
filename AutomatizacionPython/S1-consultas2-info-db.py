import pyodbc
import json
from datetime import datetime

# 1. Configuración
config = {
    'server': '127.0.0.1, 1433',
    'database': 'UsuariosApp',
    'user': 'usuario_php',
    'password': 'usuario_php'
}

conn_str = (
    f"DRIVER={{ODBC Driver 17 for SQL Server}};"
    f"SERVER={config['server']};"
    f"DATABASE={config['database']};"
    f"UID={config['user']};"
    f"PWD={config['password']};"
)

try:
    print("Conectando a la base de datos...")
    conexion = pyodbc.connect(conn_str)
    cursor = conexion.cursor()

    # Este será nuestro contenedor final para el archivo único
    data_final = {}

    # --- CONSULTA 1: Top 5 registros completos ---
    print("Ejecutando Consulta 1...")
    query1 = "SELECT TOP 5 * FROM registros"
    cursor.execute(query1)
    col1 = [column[0] for column in cursor.description]
    # Guardamos los resultados en la llave 'datos_registros'
    data_final['datos_registros'] = [dict(zip(col1, [str(v) for v in fila])) for fila in cursor.fetchall()]

    # --- CONSULTA 2: Columnas específicas (Género, Edad, Profesión) ---
    print("Ejecutando Consulta 2...")
    query2 = "SELECT genero, edad, profesion FROM registros"
    cursor.execute(query2)
    col2 = [column[0] for column in cursor.description]
    # Guardamos los resultados en la llave 'perfil_usuarios'
    data_final['perfil_usuarios'] = [dict(zip(col2, [str(v) for v in fila])) for fila in cursor.fetchall()]

    # 2. Guardar ambos resultados en un solo archivo JSON
    nombre_archivo = f"reporte_unificado_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
    
    with open(nombre_archivo, 'w', encoding='utf-8') as f:
        json.dump(data_final, f, ensure_ascii=False, indent=4)

    print(f"\n✅ Éxito. Se generó el archivo unificado: {nombre_archivo}")

except Exception as e:
    print(f"❌ Error: {e}")

finally:
    if 'conexion' in locals():
        conexion.close()
        print("\nConexión cerrada.")