
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>


<f:view>

<html>
<head>
    <title>SISTEMA</title>
    <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
    <script type="text/javascript" src='../js/general.js' ></script>
    <script type="text/javascript" src='../js/treeComponet.js' ></script> 
    <style>
        .inactivo
        {
            background-color: #fac5af;
        }
    </style>
    <script>
          function getCodigo(codigo,cod_programa_prod,cod_com_prod,cod_lote_prod,cod_formula_maestra){
                 //  alert(codigo);
                   location='../seguimiento_programa_produccion/navegador_seguimiento_programa.jsf?codigo='+codigo+'&cod_programa_prod='+cod_programa_prod+'&cod_com_prod='+cod_com_prod+'&cod_formula_maestra='+cod_formula_maestra+'&cod_lote_prod='+cod_lote_prod;
          }
          function eliminar(nametable){
               var count1=0;
               var elements1=document.getElementById(nametable);
               var rowsElement1=elements1.rows;
               //alert(rowsElement1.length);            
               for(var i=1;i<rowsElement1.length;i++){
                    var cellsElement1=rowsElement1[i].cells;
                    var cel1=cellsElement1[0];
                    if(cel1.getElementsByTagName('input').length>0){
                        if(cel1.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel1.getElementsByTagName('input')[0].checked){
                               count1++;
                           }
                        }
                    }
                    
               }
               //alert(count1);
               if(count1==0){
                    alert('No escogio ningun registro');
                    return false;
               }else{
                
                
                    if(confirm('Desea Eliminar el Registro')){
                        if(confirm('Esta seguro de Eliminar el Registro')){
                            var count=0;
                            var elements=document.getElementById(nametable);
                            var rowsElement=elements.rows;
                            
                            for(var i=0;i<rowsElement.length;i++){
                                var cellsElement=rowsElement[i].cells;
                                var cel=cellsElement[0];
                                if(cel.getElementsByTagName('input').length>0){
                                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                                        if(cel.getElementsByTagName('input')[0].checked){
                                            count++;
                                        }
                                    }
                                }

                            }
                            if(count==0){
                            //alert('No escogio ningun registro');
                            return false;
                            }
                            //var cantidadeliminar=document.getElementById('form1:cantidadeliminar');
                            //cantidadeliminar.value=count;
                            return true;
                        }else{
                            return false;
                        }
                    }else{
                        return false;
                    }
                }
           }
           function sumaTotales(nametable){
               var elements=document.getElementById(nametable);
               var rowsElement=elements.rows;
               var totalHh=0;
               var totalHm=0;
               var totalHhStd=0;
               var totalHmStd=0;

                 for(var i=1;i<rowsElement.length-1;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cellHh=cellsElement[2];
                    var cellHm=cellsElement[3];
                    var cellHhStd=cellsElement[8];
                    var cellHmStd=cellsElement[9];
                    totalHh = totalHh+ parseFloat( cellHh.getElementsByTagName('span')[0].innerHTML.replace(",","."));
                    //alert(cellHh.getElementsByTagName('span')[0].innerHTML.replace(",","."));
                    totalHm = totalHm+ parseFloat( cellHm.getElementsByTagName('input')[0].value); //.replace(".",",")
                    //alert(cellHm.getElementsByTagName('input')[0].value);
                    totalHhStd = totalHhStd+ parseFloat(cellHhStd.getElementsByTagName('span')[0].innerHTML);
                    totalHmStd = totalHmStd+ parseFloat( cellHmStd.getElementsByTagName('span')[0].innerHTML);
                    //alert(cellHhStd.getElementsByTagName('span')[0].innerHTML);
                    //alert(cellHh.getElementsByTagName('input')[0].value);
                    totalHh = Math.round(totalHh*100)/100;
                    totalHm = Math.round(totalHm*100)/100;
                    document.getElementById("form1:actividadesFormulaMaestra:totalHh").innerHTML = totalHh;
                    document.getElementById("form1:actividadesFormulaMaestra:totalHm").innerHTML = totalHm;
                    document.getElementById("form1:actividadesFormulaMaestra:totalHhStd").innerHTML = totalHhStd;
                    document.getElementById("form1:actividadesFormulaMaestra:totalHmStd").innerHTML = totalHmStd;
               }
           }
           function difFechaas(fecha){
               var fechaInicio = fecha.parentNode.parentNode.getElementsByTagName("td")[4].getElementsByTagName("input")[0].value;
               var fechaFinal = fecha.parentNode.parentNode.getElementsByTagName("td")[5].getElementsByTagName("input")[0].value;
               var fechaInicio1 = new Date(fechaInicio);
               var fechaFinal1 = new Date(fechaFinal);
               //alert(fechaInicio+":00");
               //alert(fechaFinal+":00");
               //alert(fechaFinal1.getTime()-fechaInicio1.getTime());
               var dif = (fechaFinal1-fechaInicio1)/3600000;
               //var dif = Math.round(((fechaFinal1.getTime()-fechaInicio1.getTime())/3600000.0)*100)/100;
               fecha.parentNode.parentNode.getElementsByTagName("td")[2].getElementsByTagName("span")[0].innerHTML=dif;
           }
           function prueba(elem){
               alert(elem.value.length);
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
        //inicio ale unidades medida
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
                var fecha1=obj.parentNode.parentNode.cells[6].getElementsByTagName('input')[0].value.split(" ").join("")+' '+obj.parentNode.parentNode.cells[6].getElementsByTagName('input')[1].value.split(" ").join("");
                var fecha2=obj.parentNode.parentNode.cells[7].getElementsByTagName('input')[0].value.split(" ").join("")+' '+obj.parentNode.parentNode.cells[7].getElementsByTagName('input')[1].value.split(" ").join("");
                obj.parentNode.parentNode.cells[2].getElementsByTagName('input')[0].value=getNumeroDehoras(fecha1,fecha2);
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

                 function verificarRegistrosNoDuplicados()
                    {

                        var tabla=document.getElementById('form2:listadoIngresosAcond');
                        
                        
                                var duplicado=false;
                                for(var i=1;i<tabla.rows.length;i++)
                                    {
                                         tabla.rows[i].style.backgroundColor='#FFFFFF';
                                    }
                                for(var i=1;i<tabla.rows.length;i++)
                                {
                                    if(tabla.rows[i].cells[1].getElementsByTagName('select')[0].value=='0')
                                        {
                                            tabla.rows[i].style.backgroundColor='#98FB98';
                                            duplicado=true;
                                        }
                                    for(var j=1;j<tabla.rows.length;j++)
                                        {

                                            if(j!=i)
                                                {
                                                    if((tabla.rows[i].cells[1].getElementsByTagName('select')[0].value==tabla.rows[j].cells[1].getElementsByTagName('select')[0].value)
                                                        &&(tabla.rows[i].cells[6].getElementsByTagName('INPUT')[0].value==tabla.rows[j].cells[6].getElementsByTagName('INPUT')[0].value)
                                                        &&(tabla.rows[i].cells[6].getElementsByTagName('INPUT')[1].value==tabla.rows[j].cells[6].getElementsByTagName('INPUT')[1].value)
                                                        &&(tabla.rows[i].cells[7].getElementsByTagName('INPUT')[0].value==tabla.rows[j].cells[7].getElementsByTagName('INPUT')[0].value)
                                                        &&(tabla.rows[i].cells[7].getElementsByTagName('INPUT')[1].value==tabla.rows[j].cells[7].getElementsByTagName('INPUT')[1].value))
                                                        {
                                                            tabla.rows[i].style.backgroundColor='#FFA07A';
                                                            duplicado=true;
                                                        }
                                                }
                                        }

                                }
                                if(duplicado){alert('Existen registro duplicados o sin asignar, no se puede registrar el seguimiento');}
                                return duplicado;
                           
                    }
               function tratarError() {
                    //alert('Espere Por Favor.');
                    var hasErrors = false;
                    try {




                    } catch (ex) {
                        alert('Espere Por Favor.');


                    }
                    return false;
                }
                window.onerror = tratarError;



                //window.onbeforeunload = preguntarAntesDeSalir;

                function preguntarAntesDeSalir()
                {   return "¿Seguro que quieres salir?";
                }

                function registrarActividadesDirectas(codProgramaProd,codFormulaMaestra,codCompProd,codLote,codTipoProgramaProd,codActividadFm,codAreaEmpresa)
                {
                    window.location.href='registroActividadesDirectas.jsf?codProgramaProd='+codProgramaProd+
                        '&codFormulaMaestra='+codFormulaMaestra+'&codCompProd='+codCompProd+
                        '&codLote='+codLote+'&codTipoProgramaProd='+codTipoProgramaProd+
                        '&codAreaEmpresa='+codAreaEmpresa+
                        '&codActividadFm='+codActividadFm+'&data='+(new Date()).getTime().toString();
                    

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
<body bgcolor="#F2E7F2" onload="sumaTotales('form1:actividadesFormulaMaestra');" >
<h:form id="form1"  >
<div align="center">
    <br>
    <h:outputText value="#{ManagedActividadesProgramaproduccion.cargarContenidoSeguimientoProgramaProduccion1}" styleClass="outputText2" />
    <rich:panel headerClass="headerClassACliente" style="width:80%">
        <f:facet name="header">
            <h:outputText value="Registro de Tiempos"/>
        </f:facet>
        <h:panelGrid columns="3">
            <h:outputText value="Procesos de Producción" styleClass="outputTextBold"/>
            <h:outputText value="::" styleClass="outputTextBold"/>
            <h:outputText value="#{ManagedActividadesProgramaproduccion.nombreAreaEmpresaTiempo}" styleClass="outputText2"/>
            <h:outputText value="Producto" styleClass="outputTextBold"/>
            <h:outputText value="::" styleClass="outputTextBold"/>
            <h:outputText value="#{ManagedActividadesProgramaproduccion.programaProduccion.formulaMaestra.componentesProd.nombreProdSemiterminado}" styleClass="outputText2"/>
            <h:outputText value="Lote" styleClass="outputTextBold"/>
            <h:outputText value="::" styleClass="outputTextBold"/>
            <h:outputText value="#{ManagedActividadesProgramaproduccion.programaProduccion.codLoteProduccion}" styleClass="outputText2"/>
            <h:outputText value="Presentación" styleClass="outputTextBold" rendered="#{ManagedActividadesProgramaproduccion.codAreaEmpresa eq '84'}"/>
            <h:outputText value="::" styleClass="outputTextBold" rendered="#{ManagedActividadesProgramaproduccion.codAreaEmpresa eq '84'}"/>
            <h:outputText value="#{ManagedActividadesProgramaproduccion.programaProduccion.presentacionesProducto.nombreProductoPresentacion}" styleClass="outputText2"
                          rendered="#{ManagedActividadesProgramaproduccion.codAreaEmpresa eq '84'}"/>
            
        </h:panelGrid>
    </rich:panel>
    <b> <h:outputText value="#{ManagedActividadesProgramaproduccion.nombreComProd}"   /></b> 
    <br/>
    

    <rich:dataTable value="#{ManagedActividadesProgramaproduccion.seguimientoProgramaProduccionList}"
                    var="data" rowKeyVar="index"
                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';"
                    headerClass="headerClassACliente"
                    columnClasses="tituloCampo"
                    binding="#{ManagedActividadesProgramaproduccion.seguimientoProgramaProduccionDataTable}" id="actividadesFormulaMaestra" >
        
        <f:facet name="header">
            <rich:columnGroup>
                <rich:column>
                    <h:outputText value="Orden"/>
                </rich:column>
                <rich:column>
                    <h:outputText value="Procesos de Producción"/>
                </rich:column>
                <rich:column>
                    <h:outputText value="Horas Hombre"/>
                </rich:column>
                <rich:column>
                    <h:outputText value="Horas Maquina"/>
                </rich:column>
                <rich:column>
                    <h:outputText value="Fecha Inicio"/>
                </rich:column>
                <rich:column>
                    <h:outputText value="Fecha Final"/>
                </rich:column>
                <rich:column>
                    <h:outputText value=""/>
                </rich:column>
                <rich:column>
                    <h:outputText value="Maquina"/>
                </rich:column>
                <rich:column>
                    <h:outputText value="Horas Hombre Standard"/>
                </rich:column>
                <rich:column>
                    <h:outputText value="Horas Maquina Standard"/>
                </rich:column>
                <rich:column>
                    <h:outputText value="Estado Actividad"/>
                </rich:column>
            </rich:columnGroup>
        </f:facet>    
        
            <rich:columnGroup >
                <rich:column styleClass="#{data.actividadesProduccion.estadoReferencial.codEstadoRegistro eq '1'?'':'inactivo'}">
                    <h:outputText value="#{index+1}"  />
                </rich:column>
                <rich:column styleClass="#{data.actividadesProduccion.estadoReferencial.codEstadoRegistro eq '1'?'':'inactivo'}">
                    <a4j:commandLink   styleClass="outputText2"
                                       oncomplete="if(#{ManagedActividadesProgramaproduccion.mensaje eq '1'} ){registrarActividadesDirectas(
                    '#{ManagedActividadesProgramaproduccion.programaProduccion.codProgramaProduccion}',
                    '#{ManagedActividadesProgramaproduccion.programaProduccion.formulaMaestra.codFormulaMaestra}',
                    '#{ManagedActividadesProgramaproduccion.programaProduccion.formulaMaestra.componentesProd.codCompprod}',
                    '#{ManagedActividadesProgramaproduccion.programaProduccion.codLoteProduccion}',
                    '#{ManagedActividadesProgramaproduccion.programaProduccion.tiposProgramaProduccion.codTipoProgramaProd}',
                    '#{data.actividadesFormulaMaestra.codActividadFormula}',
                    '#{ManagedActividadesProgramaproduccion.codAreaEmpresa}');}else{alert('#{ManagedActividadesProgramaproduccion.mensaje}')}"
                    action="#{ManagedActividadesProgramaproduccion.verSeguimientosProgramaProduccionPersonal_action}"><%-- rendered="#{data.habilitado==true}" --%>
                        <h:outputText value="#{data.actividadesProduccion.nombreActividad}"  />
                    </a4j:commandLink>
                </rich:column>
                <rich:column styleClass="#{data.actividadesProduccion.estadoReferencial.codEstadoRegistro eq '1'?'':'inactivo'}">
                    <h:outputText value="#{data.horasHombre}" styleClass="outputText1"   >
                        <f:convertNumber maxFractionDigits="2"  minFractionDigits="2"  />
                    </h:outputText> <%-- onblur="sumaTotales('form1:actividadesFormulaMaestra')" size="6"  onkeypress="valNum();" --%>
                </rich:column>

                <rich:column styleClass="#{data.actividadesProduccion.estadoReferencial.codEstadoRegistro eq '1'?'':'inactivo'}">
                    <h:inputText value="#{data.horasMaquina}" styleClass="inputText" size="6" onkeypress="valNum();" onkeyup="sumaTotales('form1:actividadesFormulaMaestra');" onblur="sumaTotales('form1:actividadesFormulaMaestra')" >

                    </h:inputText>
                </rich:column>
                <rich:column styleClass="#{data.actividadesProduccion.estadoReferencial.codEstadoRegistro eq '1'?'':'inactivo'}">
                    <h:outputText  value="#{data.fechaInicio}"   styleClass="outputText1"   > <%-- onblur="valFecha(this);" size="8" --%>
                        <f:convertDateTime pattern="dd/MM/yyyy" />
                    </h:outputText>

                </rich:column>
                <rich:column styleClass="#{data.actividadesProduccion.estadoReferencial.codEstadoRegistro eq '1'?'':'inactivo'}">
                    <h:outputText   value="#{data.fechaFinal}"   styleClass="outputText1" > <%-- onblur="valFecha(this);" size="8" --%>
                        <f:convertDateTime pattern="dd/MM/yyyy" />
                    </h:outputText>

                </rich:column>

                <rich:column styleClass="#{data.actividadesProduccion.estadoReferencial.codEstadoRegistro eq '1'?'':'inactivo'}">
                    <h:selectBooleanCheckbox value="#{data.checkedMaquinaria}">
                        <a4j:support timeout="40000" action="#{ManagedActividadesProgramaproduccion.llenarMaquinarias}" event="onclick" reRender="maquinaria" />
                    </h:selectBooleanCheckbox>
                </rich:column>

                <rich:column styleClass="#{data.actividadesProduccion.estadoReferencial.codEstadoRegistro eq '1'?'':'inactivo'}">
                    <h:selectOneMenu styleClass="inputText" value="#{data.maquinaria.codMaquina}" id="maquinaria"  >
                        <f:selectItems value="#{data.maquinariaList}"/>
                        <a4j:support action="#{ManagedActividadesProgramaproduccion.maquinaria_change}" reRender="horasHombreStandard,horasMaquinaStandard"
                        event="onchange" timeout="40000" />
                    </h:selectOneMenu>
                </rich:column>
                 <rich:column styleClass="#{data.actividadesProduccion.estadoReferencial.codEstadoRegistro eq '1'?'':'inactivo'}">
                    <h:outputText value="#{data.maquinariaActividadesFormula.horasHombre}" id="horasHombreStandard" />
                </rich:column>
                <rich:column styleClass="#{data.actividadesProduccion.estadoReferencial.codEstadoRegistro eq '1'?'':'inactivo'}">
                    <h:outputText value="#{data.maquinariaActividadesFormula.horasMaquina}" id="horasMaquinaStandard"  />            
                </rich:column>
                <rich:column styleClass="#{data.actividadesProduccion.estadoReferencial.codEstadoRegistro eq '1'?'':'inactivo'}">
                    <h:outputText value="#{data.actividadesProduccion.estadoReferencial.nombreEstadoRegistro}"  />
                </rich:column>
            </rich:columnGroup>
        <f:facet name="footer">
                <rich:columnGroup>
                    <rich:column>
                        <h:outputText value=""  />
                    </rich:column>
                    <rich:column>
                        <h:outputText value=""  />
                    </rich:column>
                    <rich:column>
                        <h:outputText value="0"  id="totalHh" />
                    </rich:column>
                    <rich:column>
                        <h:outputText value="0" id="totalHm"  />
                    </rich:column>
                    <rich:column>
                        <h:outputText value=""  />
                    </rich:column>
                    <rich:column>
                        <h:outputText value=""  />
                    </rich:column>
                    <rich:column>
                        <h:outputText value=""  />
                    </rich:column>
                    <rich:column>
                        <h:outputText value=""  />
                    </rich:column>
                    <rich:column>
                        <h:outputText value="0" id="totalHhStd"  />
                    </rich:column>
                    <rich:column>
                        <h:outputText value="0" id="totalHmStd"  />
                    </rich:column>
                    <rich:column>
                        <h:outputText value=""/>
                    </rich:column>
                </rich:columnGroup>

        </f:facet>
        
    </rich:dataTable>
    <br>
        <%--h:outputText value="#{ManagedActividadesProgramaproduccion.mensaje}" style="color:red" /--%>
        <br/>
    <%--h:commandButton value="Registrar" styleClass="commandButton"  action="#{ManagedActividadesFormulaMaestra.Guardar}"/>
    <h:commandButton value="Editar"  styleClass="commandButton"  action="#{ManagedActividadesFormulaMaestra.actionEditar}" onclick="return eliminarItem('form1:dataCadenaCliente');"/>
    <h:commandButton value="Eliminar"  styleClass="commandButton"  action="#{ManagedActividadesFormulaMaestra.eliminarActividadesProduccion}"  onclick="return eliminar('form1:dataCadenaCliente');"/--%>
    <%--h:commandButton value="Guardar"  styleClass="btn"  action="#{ManagedActividadesProgramaproduccion.actualizarSeguimientoProgramaProduccion_action}" onclick="if(confirm('Esta seguro de guardar la informacion?')==false){return false;}"  >
        <f:param name="url" value="../programaProduccion/navegador_programa_produccion.jsf" />
    </h:commandButton--%>
    <a4j:jsFunction action="#{ManagedActividadesProgramaproduccion.generarSolicitudAutomaticaES}" name="generarSolicitudES" oncomplete="alert('Se realizo el registro de una solicitud Automática de Empaque Secundario para el lote');atras();" timeout="40000"/>
    <a4j:jsFunction action="#{ManagedActividadesProgramaproduccion.cancelarRegistroSeguimientoProgramaProduccion_action}" name="atras" timeout="40000"/>
    <a4j:commandButton value="Guardar"  styleClass="btn"  action="#{ManagedActividadesProgramaproduccion.actualizarSeguimientoProgramaProduccion_action}" onclick="if(confirm('Esta seguro de guardar la informacion?')==false){return false;}"
    oncomplete="if(#{ManagedActividadesProgramaproduccion.mensaje eq ''}){atras();}
    else{if(#{ManagedActividadesProgramaproduccion.mensaje eq '1'}){generarSolicitudES();}else{alert('No se puede registrar la solicitud automática porque la actividad configurada para el producto no existe');atras();}}" reRender="contenidoRegistroAutomaticoSalidaES" timeout="40000" accesskey="g" />

    <h:commandButton value="Cancelar"  styleClass="btn" action="#{ManagedActividadesProgramaproduccion.cancelarRegistroSeguimientoProgramaProduccion_action}" accesskey="c" /><%-- navegadorProgramaProduccion --%>

    

</h:form>

    
         <a4j:status id="statusPeticion"
                                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
         </a4j:status>

                    <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                                     minWidth="200" height="80" width="400" zindex="400" onshow="window.focus();">

                        <div align="center">
                            <h:graphicImage value="../img/load2.gif" />
                        </div>
                    </rich:modalPanel>
         <h:panelGroup   id="panelsuper"  styleClass="panelSuper" style="visibility:hidden"  >
         </h:panelGroup>
         
         </div>


</body>
</html>

</f:view>

