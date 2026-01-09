import pyodbc  
import json
import os  
from datetime import datetime

# Configuración de conexión  a SQl server
config = {
    'server': '127.0.0.1, 1433',
    'database': 'UsuariosApp',
    'user': 'usuario_php',
    'password': 'usuario_php'
}

conn_str = f"DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={config['server']};DATABASE={config['database']};UID={config['user']};PWD={config['password']};"

def ejecutar_maestro(ruta_sql):
    try:
        # 1. VERIFICACIÓN DE RUTA: ¿El archivo existe donde me dijeron?
        if not os.path.exists(ruta_sql):
            print(f"❌ Error: No encontré el archivo en {ruta_sql}")
            print("💡 Tip: Asegúrate de poner la ruta completa, ej: C:/MisScripts/consulta.sql")
            return

        # 2. CREAR CARPETA DE LOGS: Si no existe, la crea sola
        carpeta_logs = "Accesos_SQL_Logs"
        if not os.path.exists(carpeta_logs):
            os.makedirs(carpeta_logs)
            print(f"📂 Carpeta '{carpeta_logs}' creada para guardar resultados.")

        # 3. LEER EL ARCHIVO (Usamos latin-1 por si hay tildes)
        with open(ruta_sql, 'r', encoding='latin-1') as f:
            consultas = f.read().split(';')
        
        conexion = pyodbc.connect(conn_str)
        cursor = conexion.cursor()
        reporte_final = {"archivo_origen": ruta_sql, "fecha_ejecucion": str(datetime.now())}
        
        for i, sql in enumerate(consultas):
            sql = sql.strip()
            if not sql: continue
            
            print(f"⚡ Ejecutando bloque {i+1}...")
            cursor.execute(sql)
            
            if cursor.description:
                columnas = [c[0] for c in cursor.description]
                resultados = [dict(zip(columnas, [str(v) for v in fila])) for fila in cursor.fetchall()]
                reporte_final[f"bloque_{i+1}"] = resultados
            else:
                conexion.commit()
                reporte_final[f"bloque_{i+1}"] = "Operación DML/DDL completada."

        # 4. GUARDAR DENTRO DE LA NUEVA CARPETA
        nombre_archivo = f"resultados_{datetime.now().strftime('%H%M%S')}.json"
        ruta_final_json = os.path.join(carpeta_logs, nombre_archivo) # Une Carpeta + Nombre
        
        with open(ruta_final_json, 'w', encoding='utf-8') as f:
            json.dump(reporte_final, f, indent=4, ensure_ascii=False)
            
        print(f"✅ ¡Éxito! Reporte guardado en: {ruta_final_json}")

    except Exception as e:
        print(f"❌ Error crítico: {e}")
    finally:
        if 'conexion' in locals(): conexion.close()

# --- CÓMO USARLO ---
ejecutar_maestro('devuelve-consulta.sql')
