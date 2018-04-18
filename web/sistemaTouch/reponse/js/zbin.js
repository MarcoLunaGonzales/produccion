function validarHoraFormato24(input)
{
    var areglo=input.value.split(":");
    input.style.backgroundColor='#ffffff'
    if(areglo.length!=2)
    {
        alert('Formato de hora incorrecto');
        input.style.backgroundColor='#F08080';
        input.focus();
        return false;
    }
    if(isNaN(areglo[0][1])||isNaN(areglo[0][0])||isNaN(areglo[1][0])||isNaN(areglo[1][1])||(areglo[0].length!=2)||(areglo[1].length!=2))
    {
        alert('Hora no permitida');
        input.style.backgroundColor='#F08080';
        input.focus();
        return false;
    }
    if((parseInt(areglo[0])<0)||(parseInt(areglo[0])>23))
    {
        alert('El rango de horas permitido es de 0 a 23');
        input.style.backgroundColor='#F08080';
        input.focus();
        return false;
    }
    if((parseInt(areglo[1])<0)||(parseInt(areglo[1])>59))
    {
        alert('El rango de minutos permitido es de 0 a 59');
        input.style.backgroundColor='#F08080';
        input.focus();
        return false;
    }

    return true;

}