
----------------------
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>


<f:view>

<html>
<head>
    <title>SISTEMA</title>
    <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
    <script type="text/javascript" src='../../js/general.js' ></script>
    <script type="text/javascript" src='../js/treeComponet.js' ></script>
    
    <script>
       
          function getCodigo(codigo,cod_programa_prod,cod_com_prod,cod_lote_prod,cod_formula_maestra){
                 //  alert(codigo);
                   location='../seguimiento_programa_produccion/navegador_seguimiento_programa.jsf?codigo='+codigo+'&cod_programa_prod='+cod_programa_prod+'&cod_com_prod='+cod_com_prod+'&cod_formula_maestra='+cod_formula_maestra+'&cod_lote_prod='+cod_lote_prod;
          }
           function deshabilitarPrimeraFecha(nametable){
                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   //alert(rowsElement.length);
                   if(rowsElement.length>=2){
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel0=cellsElement[0];
                    var cel1=cellsElement[1];
                    var cel3=cellsElement[3];
                    var cel4=cellsElement[4];
                    var cel5=cellsElement[5];
                    var cel6=cellsElement[6];
                    if(cel5.getElementsByTagName('input')[0].type=='text'){
                       
                        cel0.getElementsByTagName('input')[0].disabled = true;
                        cel1.getElementsByTagName('select')[0].disabled = true;
                        cel3.getElementsByTagName('input')[0].disabled = true;
                        cel4.getElementsByTagName('input')[0].disabled = true;
                        cel5.getElementsByTagName('input')[0].disabled = true;
                        cel5.getElementsByTagName('input')[1].disabled = true;
                        cel6.getElementsByTagName('input')[0].disabled = true;
                        cel6.getElementsByTagName('input')[1].disabled = true;

                     }
                     break;
                   }
                   }
                   
                }
           function redondeo2decimales(numero)
                {
                var original=parseFloat(numero);
                var result=Math.round(original*100)/100 ;
                return result;
                }
           function getNumeroDehoras(fechaIni,fechaFin)
           {
                if(fechaIni.length==16&&fechaFin.length==16)
                {
                var fec=fechaIni.split(" ");
                var d1=fec[0].split("/");
                var h1=fec[1].split(":");
                var dat1 = new Date(d1[2], parseFloat(d1[1]), parseFloat(d1[0]),parseFloat(h1[0]),parseFloat(h1[1]),0);

                 var de2 = fechaFin.split(" ");

                 var d2=de2[0].split("/");
                 var h2=de2[1].split(":");

                 var dat2 = new Date(d2[2], parseFloat(d2[1]), parseFloat(d2[0]),parseFloat(h2[0]),parseFloat(h2[1]),0);
                 var fin = dat2.getTime() - dat1.getTime();
                 var dias=0;
                 if(dat1!='NaN'&& dat2!='Nan')
                 {
                    var dias =redondeo2decimales(fin / (1000 * 60 * 60));
                 }


                return dias;
                }
                return 0;
            }
            function calcularDiferenciaFechas(obj)
            {
                var fecha1=obj.parentNode.parentNode.cells[6].getElementsByTagName('input')[0].value+' '+obj.parentNode.parentNode.cells[6].getElementsByTagName('input')[1].value;
                var fecha2=obj.parentNode.parentNode.cells[7].getElementsByTagName('input')[0].value+' '+obj.parentNode.parentNode.cells[7].getElementsByTagName('input')[1].value;
                obj.parentNode.parentNode.cells[2].getElementsByTagName('input')[0].value=getNumeroDehoras(fecha1,fecha2);
            }
            function calcularDiferenciaHoras(obj)
            {
                var fecha1=obj.parentNode.parentNode.cells[2].getElementsByTagName('input')[0].value+' '+obj.parentNode.parentNode.cells[3].getElementsByTagName('input')[0].value;
                var fecha2=obj.parentNode.parentNode.cells[2].getElementsByTagName('input')[0].value+' '+obj.parentNode.parentNode.cells[4].getElementsByTagName('input')[0].value;
                //alert(fecha1 + ' ' + fecha2);
                obj.parentNode.parentNode.cells[5].getElementsByTagName('input')[0].value=getNumeroDehoras(fecha1,fecha2);
                return true;
            }
            function posNextInput(obj)
            {
                obj.parentNode.parentNode.cells[3].getElementsByTagName('input')[0].focus();

            }
            A4J.AJAX.onError = function(req,status,message){
            window.alert("Ocurrio un error "+message+" continue con su transaccion ");
            }
            A4J.AJAX.onExpired = function(loc,expiredMsg){
            if(window.confirm("Ocurrio un error al momento realizar la transaccion: "+expiredMsg+" location: "+loc)){
            return loc;
            } else {
            return false;
            }
            }
            var tabla=null;
                function calcularTotalesTabla()
                {
                    tabla=document.getElementById("tablaDatosDefectos");
                    var sumaTotal=0;
                    if(tabla.rows[0].cells.length>2)
                    {
                        var sumaColumnas=new Array((tabla.rows[0].cells.length-2>0)?(tabla.rows[0].cells.length-2):0);
                        for(var i=0;i<sumaColumnas.length;i++)
                            {
                                sumaColumnas[i]=0;
                            }
                        for(var fila=1;fila<(tabla.rows.length-1);fila++)
                            {
                                var contCol=0;
                                var sumaDefectos=0;
                                for(var col=1;col<(tabla.rows[fila].cells.length-1);col++)
                                    {
                                        valorCelda=parseFloat(tabla.rows[fila].cells[col].getElementsByTagName('input')[0].value)
                                        sumaDefectos+=valorCelda;
                                        sumaColumnas[contCol]+=valorCelda;
                                        contCol++;
                                    }

                                    tabla.rows[fila].cells[tabla.rows[fila].cells.length-1].getElementsByTagName('span')[0].innerHTML=sumaDefectos;
                                    sumaTotal+=sumaDefectos;
                            }
                        for(var j=0;j<sumaColumnas.length;j++)
                            {
                                tabla.rows[tabla.rows.length-1].cells[j+1].getElementsByTagName('span')[0].innerHTML=sumaColumnas[j];
                            }
                        tabla.rows[tabla.rows.length-1].cells[tabla.rows[0].cells.length-1].getElementsByTagName('span')[0].innerHTML=sumaTotal;
                    }
                }
                function calcularSuma(celda)
                {
                    var sumaCol=0;
                    var sumaFila=0;
                    var columna=celda.parentNode.cellIndex;
                    var filaSuma=celda.parentNode.parentNode.rowIndex;
                    var sumaTotal=0;
                    for(var col=1;col<(tabla.rows[0].cells.length-1);col++)
                        {
                            sumaFila+=parseFloat((tabla.rows[filaSuma].cells[col].getElementsByTagName('input')[0].value!='')?tabla.rows[filaSuma].cells[col].getElementsByTagName('input')[0].value:0);
                        }
                    tabla.rows[filaSuma].cells[tabla.rows[0].cells.length-1].getElementsByTagName('span')[0].innerHTML=sumaFila;
                    var ultimaCol=tabla.rows[0].cells.length-1;
                    for(var fila=1;fila<(tabla.rows.length-1);fila++)
                        {
                            sumaTotal+=parseFloat((tabla.rows[fila].cells[ultimaCol].getElementsByTagName('span')[0].innerHTML!='')?tabla.rows[fila].cells[ultimaCol].getElementsByTagName('span')[0].innerHTML:0);
                            sumaCol+=parseFloat((tabla.rows[fila].cells[columna].getElementsByTagName('input')[0].value!='')?tabla.rows[fila].cells[columna].getElementsByTagName('input')[0].value:0);
                        }
                    tabla.rows[tabla.rows.length-1].cells[columna].getElementsByTagName('span')[0].innerHTML=sumaCol;
                    tabla.rows[tabla.rows.length-1].cells[ultimaCol].getElementsByTagName('span')[0].innerHTML=sumaTotal;

                }
                function valEnteros()
                {
                  if ((event.keyCode < 48 || event.keyCode > 57) )
                     {
                        alert('Solo puede registrar numeros enteros');
                        event.returnValue = false;
                     }
                }
                function mas_action(){
                    last = this;
                }
                function colocaFocusUltimaFila(nametable){
                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   //alert(rowsElement.length);
                   if(rowsElement.length>=2){
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel0=cellsElement[0];
                    var cel1=cellsElement[1];
                    var cel3=cellsElement[3];
                    var cel4=cellsElement[4];
                    var cel5=cellsElement[5];
                    var cel6=cellsElement[6];
                    if(cel5.getElementsByTagName('input')[0].type=='text'){
                        //alert("tiene el registro");
                          /*if(cel.getElementsByTagName('input')[0].checked){
                           count++;
                         }*/
                        //alert(cel.getElementsByTagName('input')[0].value);
                        cel0.getElementsByTagName('input')[0].disabled = true;
                        cel1.getElementsByTagName('select')[0].disabled = true;
                        cel3.getElementsByTagName('input')[0].disabled = true;
                        cel4.getElementsByTagName('input')[0].disabled = true;
                        cel5.getElementsByTagName('input')[0].disabled = true;
                        cel5.getElementsByTagName('input')[1].disabled = true;
                        cel6.getElementsByTagName('input')[0].disabled = true;
                        cel6.getElementsByTagName('input')[1].disabled = true;



                        //document.getElementById('form1:codProducto').disabled=true;
                     }
                     break;
                   }
                   }
                   //5 0,1
                   //6 0,1
                   /*if(count==1){
                      return true;
                   } else if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                   }
                   else if(count>1){
                       alert('Solo puede escoger un registro');
                       return false;
                   }*/
                }
                /*function focusUltimaFila(nametable){
                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   //alert(rowsElement.length);
                   if(rowsElement.length>=1){
                           for(var i=1;i<rowsElement.length;i++){
                            var cellsElement=rowsElement[i].cells;
                            //var cel0=cellsElement[0];
                            var cel1=cellsElement[1];
                                //cel0.getElementsByTagName('input')[0].disabled = true;
                                cel1.getElementsByTagName('select')[0].focus();                             
                           }
                   }
                   //5 0,1
                   //6 0,1
                   /*if(count==1){
                      return true;
                   } else if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                   }
                   else if(count>1){
                       alert('Solo puede escoger un registro');
                       return false;
                   }
                }*/
                function valDosDias(inputFecha)
                {
                     
                    
                    var d1=inputFecha.value.split("/");
                    
                    var dat1 = new Date(d1[2], parseFloat(d1[1])-1, parseFloat(d1[0]),0,0,0);
                     var dat2 = new Date();
                     
                     dat2.setHours(23,59,0,0);
                     
                     var fin = dat2.getTime() - dat1.getTime();
                     var dias=0;
                     if(dat1!='NaN'&& dat2!='Nan')
                     {
                         dias =redondeo2decimales(fin / (1000 * 60 * 60));
                     }
                     if(dias>47.98)
                     {
                         alert('Solo puede registrar datos de ayer y hoy');
                         inputFecha.focus();
                         return false;
                     }
                    return true;

                }
                function focusUltimaFila()
                {
                     var tabla=document.getElementById('form2:listadoSeguimientoIndirectoPersonal');
                     tabla.rows[tabla.rows.length-1].cells[1].getElementsByTagName('select')[0].focus();
                }
                function validarHora(input)
                {
                    if(input.value=='')
                        {
                            alert('Formato de hora invalido');
                            return false;
                        }
                    var arrayHora=input.value.split(":");
                 

                    if(arrayHora.length!=2)
                        {
                            alert('formato de hora incorrecto');
                            input.focus();
                            return false;
                        }
                    if(arrayHora[0]=="")
                    {
                        alert('No introdujo horas');
                        input.focus();
                        return false;
                    }
                    if(arrayHora[1]=="")
                    {
                        alert('No introdujo minutos');
                        input.focus();
                        return false;
                    }
                    if(isNaN(arrayHora[0]))
                    {
                        alert('el dato introducido como hora no es valido');
                        input.focus();
                        return false;
                    }
                    if(isNaN(arrayHora[1]))
                    {
                        alert('el dato introducido como minutos no es valido');
                        input.focus();
                        return false;
                    }
                    if(parseInt(arrayHora[0])>23 || parseInt(arrayHora[0])<0)
                        {
                            alert('la caantidad de horas debe estar entre 0 y 23 ' );
                            input.focus();
                            return false;
                        }
                    if(parseInt(arrayHora[1])>59 || parseInt(arrayHora[1])<0)
                        {
                            alert('la cantidad de minutos debe estar entre 0 y 59');
                            input.focus();
                            return false;
                        }

                }

                function validarNoHorasNegativas()
                {
                    var tabla=document.getElementById("form2:listadoSeguimientoIndirectoPersonal");
                    var registrarh=true;
                   
                    for(var i=1;i<tabla.rows.length;i++)
                        {
 
                            tabla.rows[i].style.backgroundColor='#ffffff';
                            if(parseFloat(tabla.rows[i].cells[5].getElementsByTagName('input')[0].value)<0)
                            {
                                   tabla.rows[i].style.backgroundColor='red';
                                   tabla.rows[i].onmouseout='';
                                   tabla.rows[i].onmouseover='';
                                   registrarh=false;
                            }
                        }
                        if(!registrarh)
                            {
                                alert('No se pueden registrar horas hombre negativas');
                            }
                        
                        return registrarh ;
                }
                function siguienteRegistro(input)
                {
                    
                    if(input.parentNode.parentNode.rowIndex < input.parentNode.parentNode.parentNode.rows.length)
                    {
                         var a=input.parentNode.parentNode.parentNode.rows[input.parentNode.parentNode.rowIndex].cells[0].getElementsByTagName('input')[0];
                         a.focus();
                         
                    }
                    else
                        {
                            document.getElementById("form2:masAction").focus();
                        }
                    document.selection.empty();

                }
                A4J.AJAX.onError = function(req,status,message){
            window.alert("Ocurrio un error: "+message);
            }
            A4J.AJAX.onExpired = function(loc,expiredMsg){
            if(window.confirm("Ocurrio un error al momento realizar la transaccion: "+expiredMsg+" location: "+loc)){
            return loc;
            } else {
            return false;
            }
            }
            
            var bPreguntar = true;
            window.onbeforeunload = preguntarAntesDeSalir;
            function preguntarAntesDeSalir()
            {
            if (bPreguntar)
            return "¿Seguro que quieres salir? Podría perder todos los cambios si no los GUARDO";
            }
        </script>
        <style type="text/css">
            .input{
                border:none;
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 11px;
            }
        </style>
        <%--final ale unidades medida sumaTotales('form1:actividadesFormulaMaestra') --%>
        
</head>
<body bgcolor="#F2E7F2" onload="" >
                
                <div align="center">
                        <a4j:form id="form2">
                            <h:outputText value="#{ManagedProgramaProduccion.cargarSeguimientoActividadesIndirectas_action}" />
                             <h:panelGroup id="contenidoSeguimientoProgramaProduccionPersonal" >
                                <div align="center">
                                 <h:panelGrid columns="2"  styleClass="navegadorTabla" headerClass="headerClassACliente" style="border:1px solid #0A5B99;" id="datosSolicitudMantenimiento">
                                        <f:facet name="header">
                                            <h:outputText value="Datos Programa Produccion"  />
                                        </f:facet>
                                        <h:outputText value="Programa Producción :" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="#{ManagedProgramaProduccion.programaProduccionPeriodoIndirectas.nombreProgramaProduccion}" styleClass="outputText2"   />
                                        <h:outputText value="Observación :" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="#{ManagedProgramaProduccion.programaProduccionPeriodoIndirectas.obsProgramaProduccion}" styleClass = "outputText2" />
                                        <h:outputText value="Actividad :" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="#{ManagedProgramaProduccion.seguimientoIndirecto.actividadesProgramaProduccionIndirecto.actividadesProduccion.nombreActividad}" styleClass = "outputText2" />
                                        <h:outputText value="Area :" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="#{ManagedProgramaProduccion.seguimientoIndirecto.actividadesProgramaProduccionIndirecto.areasEmpresa.nombreAreaEmpresa}" styleClass = "outputText2" />
                                 </h:panelGrid>
                            <rich:dataTable value="#{ManagedProgramaProduccion.seguimientoIndirecto.listaSeguimientoPersonal}" var="data"
                                        id="listadoSeguimientoIndirectoPersonal"

                                        headerClass="headerClassACliente" 
                                        align="center"  style="margin-top:5px;">
                                    <rich:column>
                                        <f:facet name="header">
                                            <h:outputText value="" styleClass="outputText2" />
                                        </f:facet>
                                        <h:selectBooleanCheckbox value="#{data.checked}" />
                                    </rich:column>
                                    <rich:column>
                                        <f:facet name="header">
                                            <h:outputText value="Personal"  />
                                        </f:facet>
                                       <h:selectOneMenu value="#{data.personal.codPersonal}" styleClass="inputText" >
                                    <f:selectItems value="#{ManagedProgramaProduccion.listaPersonal}" />
                                        </h:selectOneMenu>
                                    </rich:column>
                                   
                                     <rich:column>
                                            <f:facet name="header">
                                                <h:outputText value="Fecha" styleClass="outputText2" />
                                            </f:facet>
                                            <h:inputText value="#{data.fechaInicio}" styleClass="inputText" onblur="if(valFecha(this)==false){this.focus();}"   size="10" onkeyup="calcularDiferenciaHoras(this)"> <%-- onblur="if(valFecha(this)==true){valDosDias(this)}" --%>
                                                <f:convertDateTime pattern="dd/MM/yyyy"/>
                                            </h:inputText>
                                        </rich:column>
                                        <rich:column>
                                            <f:facet name="header">
                                                <h:outputText value="H. inicio" styleClass="outputText2" />
                                            </f:facet>
                                            <h:inputText value="#{data.horaInicio}" styleClass="inputText" size="5" onkeyup="calcularDiferenciaHoras(this)" onblur="validarHora(this)">
                                                <f:convertDateTime pattern="HH:mm"/>
                                            </h:inputText>
                                        </rich:column>
                                        <rich:column>
                                            <f:facet name="header">
                                                <h:outputText value="H. final" styleClass="outputText2" />
                                            </f:facet>
                                            <h:inputText value="#{data.horaFinal}" styleClass="inputText" size="5" onkeyup="calcularDiferenciaHoras(this)" onblur="validarHora(this)">
                                                <f:convertDateTime pattern="HH:mm"/>
                                            </h:inputText>
                                        </rich:column>
                                         <rich:column>
                                        <f:facet name="header">
                                            <h:outputText value="Horas Hombre" styleClass="outputText2" />
                                        </f:facet>
                                        <h:inputText value="#{data.horarHombre}" onfocus="siguienteRegistro(this);" styleClass="input" id="horasHombre" size="6">
                                            <f:convertNumber pattern="##0.00" locale="en"  />
                                        </h:inputText>
                                    </rich:column>
                        </rich:dataTable>

                        <br/>

                        <a4j:commandLink accesskey="q" action="#{ManagedProgramaProduccion.mas_action}" id="masAction" reRender="listadoSeguimientoIndirectoPersonal" timeout="30000" oncomplete="focusUltimaFila()">
                            <h:graphicImage url="../../img/mas.png" alt="mas"/>
                        </a4j:commandLink>
                        <a4j:commandLink accesskey="w" action="#{ManagedProgramaProduccion.menos_action}" reRender="listadoSeguimientoIndirectoPersonal" timeout="30000">
                            <h:graphicImage url="../../img/menos.png" alt="menos"/>
                        </a4j:commandLink>
                        <br>
                            <h:commandButton accesskey="g" onclick="bPreguntar = false;if(validarNoHorasNegativas()==false){return false;}"  styleClass="btn" value="Guardar" action="#{ManagedProgramaProduccion.guardarSeguimientoPersonal}" />
                            <h:commandButton styleClass="btn" value="Cancelar" action="#{ManagedProgramaProduccion.cancelarSeguimientoProgramaProduccionIndirecto_action}"
                            accesskey="c"/>
                         <%--input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelSeguimientoProgramaProduccionPersonal')" class="btn" /--%>


                            </div>
                            </h:panelGroup>
                            <a4j:status id="statusPeticion"
                                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
                    </a4j:status>

                    <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                                     minWidth="200" height="80" width="400" zindex="400" onshow="window.focus();">

                        <div align="center">
                            <h:graphicImage value="../../img/load2.gif" />
                        </div>
                    </rich:modalPanel>
                        </a4j:form>

    
                </div>
</body>
</html>

</f:view>

