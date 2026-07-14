from PIL import Image
import numpy as np
import sys

# Verificar si se proporcionó el nombre del archivo
if len(sys.argv) < 2:
    print("Uso: python script.py <nombre_imagen.png>")
    sys.exit(1)

nombre_imagen = sys.argv[1]

try:
    im = Image.open(nombre_imagen)
except FileNotFoundError:
    print(f"Error: No se encontró el archivo '{nombre_imagen}'")
    sys.exit(1)

# Convertir a RGB si está en modo paleta
if im.mode == 'P':
    im = im.convert('RGB')

img = np.array(im)

# Verificar dimensiones
if img.shape[0] != 64 or img.shape[1] != 64:
    print(f"Advertencia: La imagen debe ser 64x64. Dimensiones actuales: {img.shape[1]}x{img.shape[0]}")

# Generar nombre de archivo de salida
nombre_salida = "../image.hex"

# Abrir archivo para escritura
with open(nombre_salida, "w") as f:
    
    for y in range(32):  # Mitad superior (filas 0-31)
        for x in range(64):  # Todas las columnas
            # Pixel mitad superior (y)
            r1 = (img[y,x,0] >> 7)      
            g1 = (img[y,x,1] >> 7)      
            b1 = (img[y,x,2] >> 7)      
            
            # Pixel mitad inferior (y+32)
            r2 = (img[y+32,x,0] >> 7)   
            g2 = (img[y+32,x,1] >> 7)   
            b2 = (img[y+32,x,2] >> 7)   
            
            # Formato: R1G1B1R2G2B2
            pixel_data = (b1 << 5) | (g1 << 4) | (r1 << 3) | (b2 << 2) | (g2 << 1) | r2
            
            f.write("%02X\n" % pixel_data)

print(f"Archivo generado: {nombre_salida}")