function validarRegistroEntero(inputNumero){
      inputNumero.value=(inputNumero.value==''?'0':inputNumero.value);
      inputNumero.style.backgroundColor='#ffffff';
       if (isNaN(inputNumero.value)){
           inputNumero.style.backgroundColor='#F08080';
            inputNumero.focus();
            alertJs("No se reconoce el numero "+inputNumero.value);
            return false;
        }
        else{
            if (inputNumero.value % 1 == 0) {
                return true;
            }
            else{
                inputNumero.style.backgroundColor='#F08080';
                inputNumero.focus();
                alertJs ("Solo se permiten numeros enteros");
                return false;
            }
        }
        alertJs("Numero invalido")
        inputNumero.style.backgroundColor='#F08080';
        inputNumero.focus();
        return false;
    }

function validarSeleccionRegistro(select)
{
    select.style.backgroundColor='#ffffff';
    if(!(parseInt(select.value)!=0))
    {
        select.style.backgroundColor='#F08080';
        select.focus();
        alertJs('Debe seleccionar una opcion');
        return false;
    }
    return true;
}
function validarHoraRegistro(input)
    {
        var areglo=input.value.split(":");
        input.style.backgroundColor='#ffffff';
        if(areglo.length!=2)
        {
            alertJs('Formato de hora incorrecto');
            input.style.backgroundColor='#F08080';
            input.focus();
            return false;
        }
        if(isNaN(areglo[0][1])||isNaN(areglo[0][0])||isNaN(areglo[1][0])||isNaN(areglo[1][1])||(areglo[0].length!=2)||(areglo[1].length!=2))
        {
            alertJs('Hora no permitida');
            input.style.backgroundColor='#F08080';
            input.focus();
            return false;
        }
        if((parseInt(areglo[0])<0)||(parseInt(areglo[0])>23))
        {
            alertJs('El rango de horas permitido es de 0 a 23');
            input.style.backgroundColor='#F08080';
            input.focus();
            return false;
        }
        if((parseInt(areglo[1])<0)||(parseInt(areglo[1])>59))
        {
            alertJs('El rango de minutos permitido es de 0 a 59');
            input.style.backgroundColor='#F08080';
            input.focus();
            return false;
        }

        return true;

    }
function valDia(oTxt)
{
    var bOk = false;
    var nDia = parseInt(oTxt.value.substr(0, 2), 10);
    bOk = bOk || ((nDia >= 1) && (nDia <= finMes(oTxt)));
    return bOk;
}

function valMes(oTxt)
{
    var bOk = false;
    var nMes = parseInt(oTxt.value.substr(3, 2), 10);
    bOk = bOk || ((nMes >= 1) && (nMes <= 12));
    return bOk;
}

function valAno(oTxt)
{
    var bOk = true;
    var nAno = oTxt.value.substr(6);
    /*bOk = bOk && ((nAno.length == 2) || (nAno.length == 4));*/
    bOk = bOk && (nAno.length == 4) && (nAno>1000) ;
    if (bOk){
        for (var i = 0; i < nAno.length; i++){
        bOk = bOk && esDigito(nAno.charAt(i));
        }
    }
    return bOk;
}

function valSep(oTxt)
{
    var bOk = false;
    bOk = bOk || ((oTxt.value.charAt(2) == "-") && (oTxt.value.charAt(5) == "-"));
    bOk = bOk || ((oTxt.value.charAt(2) == "/") && (oTxt.value.charAt(5) == "/"));
    return bOk;
}

function esDigito(sChr)
{
    var sCod = sChr.charCodeAt(0);
    return ((sCod > 47) && (sCod < 58));
}
function finMes(oTxt)
{
    var nMes = parseInt(oTxt.value.substr(3, 2), 10);
    var nRes = 0;
    switch (nMes){
    case 1: nRes = 31; break;
    case 2: nRes = 29; break;
    case 3: nRes = 31; break;
    case 4: nRes = 30; break;
    case 5: nRes = 31; break;
    case 6: nRes = 30; break;
    case 7: nRes = 31; break;
    case 8: nRes = 31; break;
    case 9: nRes = 30; break;
    case 10: nRes = 31; break;
    case 11: nRes = 30; break;
    case 12: nRes = 31; break;
    }
    return nRes;
}

function validarFechaRegistro(input)
{
        input.style.backgroundColor='#ffffff';
        var registrar = true;
        if (input.value == ""){
            alertJs("Formato de Fecha Incorrecto");
            input.style.backgroundColor='#F08080';
            input.focus();
            return false;
        }
        if (input.value != ""){
        registrar = registrar && (valAno(input));
        registrar = registrar && (valMes(input));
        registrar = registrar && (valDia(input));
        registrar = registrar && (valSep(input));
        if (!registrar){
            alertJs("Formato de Fecha Incorrecto");
            input.style.backgroundColor='#F08080';
            input.focus();
            return false;
        }
      }
      return true;
}

function validarRegistrosHorasNoNegativas(inputHoraInicio,inputHoraFinal)
{

    var horaIni=parseInt(inputHoraInicio.value.split(":")[0]);
    var horaFin=parseInt(inputHoraFinal.value.split(":")[0]);
    if(horaFin>horaIni)
    {
        inputHoraInicio.style.backgroundColor='#ffffff';
        inputHoraFinal.style.backgroundColor='#ffffff';
        return true;
    }
    if(horaFin<horaIni)
    {
        inputHoraInicio.style.backgroundColor='#F08080';
        inputHoraFinal.style.backgroundColor='#F08080';
        inputHoraInicio.focus();
        alertJs('La hora final debe ser mayor a la hora inicial');
        return false;
    }
    else
    {
        if(parseInt(inputHoraFinal.value.split(":")[1])>parseInt(inputHoraInicio.value.split(":")[1]))
        {
            inputHoraInicio.style.backgroundColor='#ffffff';
            inputHoraFinal.style.backgroundColor='#ffffff';
            return true;
        }
        else
        {
            inputHoraInicio.style.backgroundColor='#F08080';
            inputHoraFinal.style.backgroundColor='#F08080';
            inputHoraInicio.focus();
            alertJs('La hora final debe ser mayor a la hora inicial');
            return false;
        }
    }
    return false
}

