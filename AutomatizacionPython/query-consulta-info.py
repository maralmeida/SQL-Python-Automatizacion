# consulta registros via select a a base de datos SQL Server usando pyodbc

import pyodbc

# 1. Configuración
config = {
    'server': '127.0.0.1, 1433',        # nombre o la IP de tu servidor
    'database': 'UsuariosApp',
    'user': 'usuario_php',                 # Tu usuario
    'password': 'usuario_php'
}

# 2. Cadena de conexión
conn_str = (
    f"DRIVER={{ODBC Driver 17 for SQL Server}};"
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
    query = "SELECT TOP 5 * FROM registros" # Cambia 'registos' por tu tabla
    cursor.execute(query)

    # 5. Obtener y mostrar resultados
    columnas = [column[0] for column in cursor.description]
    print(f"\nColumnas: {columnas}")
    print("-" * 50)

    for fila in cursor.fetchall():
        print(fila)

except Exception as e:
    print(f"Error: {e}")

finally:
    # 6. Cerrar conexión
    if 'conexion' in locals():
        conexion.close()
        print("\nConexión cerrada.")