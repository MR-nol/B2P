numerosEnterosDecimales = str([1,2,3,4,5,6,7,8,9,])
for numerosEnterosDecimales in range(10):
    rutaSeleccionada = "/dev/sda1p4"

    indiceRuta = rutaSeleccionada.find(numerosEnterosDecimales)
    print(indiceRuta)