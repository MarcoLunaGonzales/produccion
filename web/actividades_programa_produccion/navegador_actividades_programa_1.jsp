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
                    totalHm = totalHm+ parseFloat( cellHm.getElementsByTagName('input')[0].value.replace(".",","));
                    totalHhStd = totalHhStd+ parseFloat(cellHhStd.getElementsByTagName('span')[0].innerHTML);
                    totalHmStd = totalHmStd+ parseFloat( cellHmStd.getElementsByTagName('span')[0].innerHTML);
                    //alert(cellHhStd.getElementsByTagName('span')[0].innerHTML);
                    //alert(cellHh.getElementsByTagName('input')[0].value);
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
                var fecha1=obj.parentNode.parentNode.cells[6].getElementsByTagName('input')[0].value+' '+obj.parentNode.parentNode.cells[6].getElementsByTagName('input')[1].value;
                var fecha2=obj.parentNode.parentNode.cells[7].getElementsByTagName('input')[0].value+' '+obj.parentNode.parentNode.cells[7].getElementsByTagName('input')[1].value;
                obj.parentNode.parentNode.cells[2].getElementsByTagName('input')[0].value=getNumeroDehoras(fecha1,fecha2);
            }
            function posNextInput(obj)
            {
                obj.parentNode.parentNode.cells[3].getElementsByTagName('input')[0].focus();

            }
            A4J.AJAX.onError = function(req,status,message){
            window.alert("Ocurrio un error: "+message);
            }
            A4J.AJAX.onExpired = function(loc,expiredMsg){
            if(window.confirm("Ocurrio un error al momento realizar la transaccion Intente nuevamente \n Error: "+expiredMsg+" location: "+loc)){
            return loc;
            } else {
            return false;
            }
            }
        </script>
        <style type="text/css">
            .input{
                border:none;
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 11px;
            }
        </style>
        <%--final ale unidades medida--%>
        
</head>
<body bgcolor="#F2E7F2" onload="sumaTotales('form1:actividadesFormulaMaestra')" >
<h:form id="form1"  >                
<div align="center">                    
    <br>
        <h:outputText value="#{ManagedActividadesProgramaproduccion.cargarContenidoSeguimientoProgramaProduccion1}" styleClass="outputText2" />
    <h:outputText value="Procesos de Producción" styleClass="tituloCabezera1"    />
    <br/><b>Producto:</b> <h:outputText value="#{ManagedActividadesProgramaproduccion.programaProduccion.formulaMaestra.componentesProd.nombreProdSemiterminado}" styleClass="tituloCabezera1"    />
    <br/><b>Lote:</b><h:outputText value="#{ManagedActividadesProgramaproduccion.programaProduccion.codLoteProduccion}" styleClass="tituloCabezera1"    />
    <%--h:panelGroup rendered="#{ManagedActividadesProgramaproduccion.codAreaEmpresa eq '84'}"--%>
    Presentacion :
    <h:selectOneMenu styleClass="inputText" value="#{ManagedActividadesProgramaproduccion.codPresentacion}" >
            <f:selectItems  value="#{ManagedActividadesProgramaproduccion.presentacionesProductoList}" />
            <a4j:support event="onchange" action="#{ManagedActividadesProgramaproduccion.presentacionesProducto_change}" reRender="actividadesFormulaMaestra" />
        </h:selectOneMenu>
   <%--/h:panelGroup--%>

    <br> <br> <b> <h:outputText value="#{ManagedActividadesProgramaproduccion.nombreComProd}"   /></b> 
    <br>
    <br>
    <%--rich:dataTable value="#{ManagedActividadesProgramaproduccion.actividadesList}" var="data" id="dataCadenaCliente"
                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                    headerClass="headerClassACliente"
                    columnClasses="tituloCampo" >
        <h:column>
            <f:facet name="header">
                <h:outputText value=""  />
                
            </f:facet>
            <h:selectBooleanCheckbox value="#{data.checked}"  />
        </h:column>
        <h:column>
            <f:facet name="header">
                <h:outputText value="Orden"  />
            </f:facet>
            <h:outputText value="#{data.ordenActividad}"  />
        </h:column>
        <h:column>
            <f:facet name="header">
                <h:outputText value="Procesos de Producción"  />
            </f:facet>
            <h:outputText value="#{data.actividadesProduccion.nombreActividad}"  />
        </h:column>
  
        <h:column>
            <f:facet name="header">
                <h:outputText value=" Detalle"  />
            </f:facet>
            <h:outputText value="<a  onclick=\"getCodigo('#{data.codActividadPrograma}','#{ManagedActividadesProgramaproduccion.codigoProgramaProd}','#{ManagedActividadesProgramaproduccion.codigoCompProd}','#{ManagedActividadesProgramaproduccion.codigoLoteProd}','#{ManagedActividadesProgramaproduccion.codigoFormulaMaestra}');\" style='cursor:hand;text-decoration:underline' ><img src='../img/organigrama3.jpg' alt='Procesos Producción '></a>  "  escape="false"  />
        </h:column>           
    </rich:dataTable--%>

    <rich:dataTable value="#{ManagedActividadesProgramaproduccion.seguimientoProgramaProduccionList}"
                    var="data"
                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';"
                    headerClass="headerClassACliente"
                    columnClasses="tituloCampo"
                    binding="#{ManagedActividadesProgramaproduccion.seguimientoProgramaProduccionDataTable}" id="actividadesFormulaMaestra" >

        <h:column>
            <f:facet name="header">
                <h:outputText value="Orden"  />
            </f:facet>
            <h:outputText value="#{data.actividadesFormulaMaestra.ordenActividad}"  />
        </h:column>
        <h:column>
            <f:facet name="header">
                <h:outputText value="Procesos de Producción"  />
            </f:facet>
            <a4j:commandLink styleClass="outputText2" action="#{ManagedActividadesProgramaproduccion.verSeguimientoProgramaProduccionPersonal_action}"
            oncomplete="Richfaces.showModalPanel('panelSeguimientoProgramaProduccionPersonal');if(#{data.habilitado==false}){deshabilitarPrimeraFecha('form2:listadoIngresosAcond')}" reRender="contenidoSeguimientoProgramaProduccionPersonal"><%-- rendered="#{data.habilitado==true}" --%>
            <h:outputText value="#{data.actividadesProduccion.nombreActividad}"  />
            </a4j:commandLink>
            <%--h:outputText value="#{data.actividadesProduccion.nombreActividad}" rendered="#{data.habilitado==false}"/--%>
        </h:column>
        <h:column>
            <f:facet name="header">
                <h:outputText value="Horas Hombre"  />
            </f:facet>
            <h:outputText value="#{data.horasHombre}" styleClass="outputText1"   >
                <f:convertNumber maxFractionDigits="2"  minFractionDigits="2"  />
            </h:outputText> <%-- onblur="sumaTotales('form1:actividadesFormulaMaestra')" size="6"  onkeypress="valNum();" --%>
        </h:column>
        
        <h:column>
            <f:facet name="header">
                <h:outputText value="Horas Máquina"  />
            </f:facet>
            <h:inputText value="#{data.horasMaquina}" styleClass="inputText" size="6" onkeypress="valNum();" onblur="sumaTotales('form1:actividadesFormulaMaestra')" >
                
            </h:inputText>
        </h:column>
        <h:column>
            <f:facet name="header">
                <h:outputText value="Fecha Inicio"  />
            </f:facet>
            <h:outputText  value="#{data.fechaInicio}"   styleClass="outputText1"   > <%-- onblur="valFecha(this);" size="8" --%>
                <f:convertDateTime pattern="dd/MM/yyyy" />
            </h:outputText>

        </h:column>
        <h:column>
            <f:facet name="header">
                <h:outputText value="Fecha Final"  />
            </f:facet>
            <h:outputText   value="#{data.fechaFinal}"   styleClass="outputText1" > <%-- onblur="valFecha(this);" size="8" --%>
                <f:convertDateTime pattern="dd/MM/yyyy" />
            </h:outputText>
            
        </h:column>

        <h:column>
            <f:facet name="header">
                <h:outputText value=""  />
            </f:facet>
            <h:selectBooleanCheckbox value="#{data.checkedMaquinaria}">
                <a4j:support action="#{ManagedActividadesProgramaproduccion.llenarMaquinarias}" event="onclick" reRender="maquinaria" />
            </h:selectBooleanCheckbox>
        </h:column>

        <h:column>
            <f:facet name="header">
                <h:outputText value="Maquina"  />
            </f:facet>
            <h:selectOneMenu styleClass="inputText" value="#{data.maquinaria.codMaquina}" id="maquinaria"  >
                <f:selectItems value="#{data.maquinariaList}"/>
                <a4j:support action="#{ManagedActividadesProgramaproduccion.maquinaria_change}" reRender="horasHombreStandard,horasMaquinaStandard"
                event="onchange" />
            </h:selectOneMenu>
        </h:column>
         <h:column>
            <f:facet name="header">
                <h:outputText value="Horas Hombre Standard"  />
            </f:facet>
            <h:outputText value="#{data.maquinariaActividadesFormula.horasHombre}" id="horasHombreStandard" />
        </h:column>
        <h:column>
            <f:facet name="header">
                <h:outputText value="Horas Maquina Standard"  />
            </f:facet>
            <h:outputText value="#{data.maquinariaActividadesFormula.horasMaquina}" id="horasMaquinaStandard"  />            
        </h:column>

        <f:facet name="footer">
                <rich:columnGroup>
                    <h:column>
                        <h:outputText value=""  />
                    </h:column>
                    <h:column>
                        <h:outputText value=""  />
                    </h:column>
                    <h:column>
                        <h:outputText value="0"  id="totalHh" />
                    </h:column>
                    <h:column>
                        <h:outputText value="0" id="totalHm"  />
                    </h:column>
                    <h:column>
                        <h:outputText value=""  />
                    </h:column>
                    <h:column>
                        <h:outputText value=""  />
                    </h:column>
                    <h:column>
                        <h:outputText value=""  />
                    </h:column>
                    <h:column>
                        <h:outputText value=""  />
                    </h:column>
                    <h:column>
                        <h:outputText value="0" id="totalHhStd"  />
                    </h:column>
                    <h:column>
                        <h:outputText value="0" id="totalHmStd"  />
                    </h:column>
                </rich:columnGroup>

        </f:facet>
        
    </rich:dataTable>
    
    
    <br>
    <%--h:commandButton value="Registrar" styleClass="commandButton"  action="#{ManagedActividadesFormulaMaestra.Guardar}"/>
    <h:commandButton value="Editar"  styleClass="commandButton"  action="#{ManagedActividadesFormulaMaestra.actionEditar}" onclick="return eliminarItem('form1:dataCadenaCliente');"/>
    <h:commandButton value="Eliminar"  styleClass="commandButton"  action="#{ManagedActividadesFormulaMaestra.eliminarActividadesProduccion}"  onclick="return eliminar('form1:dataCadenaCliente');"/--%>
    <%--h:commandButton value="Guardar"  styleClass="btn"  action="#{ManagedActividadesProgramaproduccion.actualizarSeguimientoProgramaProduccion_action}" onclick="if(confirm('Esta seguro de guardar la informacion?')==false){return false;}"  >
        <f:param name="url" value="../programaProduccion/navegador_programa_produccion.jsf" />
    </h:commandButton--%>
    <a4j:jsFunction action="#{ManagedActividadesProgramaproduccion.generarSolicitudAutomaticaES}" name="generarSolicitudES" oncomplete="alert('Se realizo el registro de una solicitud Automática de Empaque Secundario para el lote');atras();"/>
    <a4j:jsFunction action="#{ManagedActividadesProgramaproduccion.cancelarRegistroSeguimientoProgramaProduccion_action}" name="atras"/>
    <a4j:commandButton value="Guardar"  styleClass="btn"  action="#{ManagedActividadesProgramaproduccion.actualizarSeguimientoProgramaProduccion_action}" onclick="if(confirm('Esta seguro de guardar la informacion?')==false){return false;}"
    oncomplete="if(#{ManagedActividadesProgramaproduccion.mensaje eq ''}){atras();}
    else{if(#{ManagedActividadesProgramaproduccion.mensaje eq '1'}){generarSolicitudES();}else{alert('No se puede registrar la solicitud automática porque la actividad configurada para el producto no existe');atras();}}" reRender="contenidoRegistroAutomaticoSalidaES"/>

    <h:commandButton value="Cancelar"  styleClass="btn" action="#{ManagedActividadesProgramaproduccion.cancelarRegistroSeguimientoProgramaProduccion_action}" /><%-- navegadorProgramaProduccion --%>

    

<!--cerrando la conexion-->
<h:outputText value="#{ManagedActividadesFormulaMaestra.closeConnection}"  />
</h:form>
    <rich:modalPanel id="panelSeguimientoProgramaProduccionPersonal" minHeight="300"  minWidth="950"
                                     height="300" width="950"  zindex="200"  headerClass="headerClassACliente"
                                     resizeable="false" style="overflow:auto">
                        <f:facet name="header">
                            <h:outputText value="Detalle de Seguimiento"/>
                        </f:facet>
                        <a4j:form id="form2">
                            <h:panelGroup id="contenidoSeguimientoProgramaProduccionPersonal" >
                            <div align="center">
                                Actividad:
                                <h:outputText value="#{ManagedActividadesProgramaproduccion.seguimientoProgramaProduccion.actividadesProduccion.nombreActividad}" />
                             <rich:dataTable value="#{ManagedActividadesProgramaproduccion.seguimientoProgramaProduccion.seguimientoProgramaProduccionPersonalList}" var="data"
                                        id="listadoIngresosAcond"
                                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                        onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                        headerClass="headerClassACliente"
                                        align="center" binding="#{ManagedActividadesProgramaproduccion.seguimientoProgramaProduccionPersonalDataTable}" >
                            <h:column>
                                <f:facet name="header">
                                    <h:outputText value=""  />
                                </f:facet>
                                <h:selectBooleanCheckbox value="#{data.checked}"  />
                            </h:column>
                                    <%--rich:column>
                                        <f:facet name="header">
                                            <h:outputText value="Personal"  />
                                        </f:facet>
                                        <h:outputText value="#{data.personal.nombrePersonal}" /> &nbsp;
                                        <h:outputText value="#{data.personal.apPaternoPersonal}" /> &nbsp;
                                        <h:outputText value="#{data.personal.apMaternoPersonal}" />
                                    </rich:column--%>
                                    <rich:column>
                                        <f:facet name="header">
                                            <h:outputText value="Personal"  />
                                        </f:facet>
                                        <h:selectOneMenu value="#{data.personal.codPersonal}" styleClass="inputText">
                                            <f:selectItems value="#{ManagedActividadesProgramaproduccion.personalList}" />
                                        </h:selectOneMenu>
                                    </rich:column>
                                    <%--rich:column>
                                        <f:facet name="header">
                                            <h:outputText value="Horas Hombre" styleClass="outputText2" />
                                        </f:facet>
                                        <h:outputText value="#{data.horasHombre}" styleClass="outputText1" id="horasHombre">
                                            <f:convertNumber maxFractionDigits="2"  minFractionDigits="2" pattern="##,###.00"  />
                                        </h:outputText>
                                    </rich:column--%>
                                    <%--inicio ale unidades medida--%>
                                    <rich:column>
                                        <f:facet name="header">
                                            <h:outputText value="Horas Hombre" styleClass="outputText2" />
                                        </f:facet>
                                        <h:inputText value="#{data.horasHombre}"  styleClass="input" id="horasHombre" onfocus="posNextInput(this)" size="6">
                                            <f:convertNumber pattern="###.00" locale="en"  />
                                            </h:inputText>
                                    </rich:column>
                                    <%--final ale unidades medida--%>
                                    <rich:column>
                                        <f:facet name="header">
                                            <h:outputText value="Unidades Producidas" styleClass="outputText2" />
                                        </f:facet>
                                        <h:inputText value="#{data.unidadesProducidas}" styleClass="inputText" size="5" onkeypress="valNum();"/>
                                    </rich:column>
                                    <rich:column>
                                        <f:facet name="header">
                                            <h:outputText value="Horas Extra" styleClass="outputText2" />
                                        </f:facet>
                                        <h:inputText value="#{data.horasExtra}" styleClass="inputText" id="horasExtra" size="5" onkeypress="valNum();">
                                            <f:convertNumber pattern="###.00" locale="en"/>
                                        </h:inputText>
                                    </rich:column>
                                    <rich:column>
                                        <f:facet name="header">
                                            <h:outputText value="Unidades Producidas Extra" styleClass="outputText2" />
                                        </f:facet>
                                        <h:inputText value="#{data.unidadesProducidasExtra}" styleClass="inputText" size="5" onkeypress="valNum();"/>

                                        <h:outputText value="[#{ManagedActividadesProgramaproduccion.seguimientoProgramaProduccion.actividadesProduccion.unidadesMedida.abreviatura}]" styleClass="outputText2" />

                                    </rich:column>
                                    <%--rich:column>
                                        <f:facet name="header">
                                            <h:outputText value="Fecha Inicio" styleClass="outputText2" />
                                        </f:facet>
                                        <h:inputText value="#{data.fechaInicio}" styleClass="inputText" size="10">
                                            <f:convertDateTime pattern="dd/MM/yyyy"/>
                                            <a4j:support action="#{ManagedActividadesProgramaproduccion.fechas_change1}" reRender="horasHombre" onsubmit="if(this.value.length<10){return false;}" event="onkeyup" />
                                        </h:inputText>
                                        <h:inputText value="#{data.horaInicio}" styleClass="inputText" size="5">
                                            <f:convertDateTime pattern="HH:mm"/>
                                            <a4j:support action="#{ManagedActividadesProgramaproduccion.fechas_change1}" reRender="horasHombre" onsubmit="if(this.value.length<5){return false;}" event="onkeyup" />
                                        </h:inputText>
                                    </rich:column>
                                    <rich:column>
                                        <f:facet name="header">
                                            <h:outputText value="Fecha Final" styleClass="outputText2" />
                                        </f:facet>
                                        <h:inputText value="#{data.fechaFinal}" styleClass="inputText" size ="10">
                                            <f:convertDateTime pattern="dd/MM/yyyy"/>
                                            <a4j:support action="#{ManagedActividadesProgramaproduccion.fechas_change1}" reRender="horasHombre" onsubmit="if(this.value.length<10){return false;}" event="onkeyup" />
                                        </h:inputText>
                                        <h:inputText value="#{data.horaFinal}" styleClass="inputText" size ="5">
                                            <f:convertDateTime pattern="HH:mm"/>
                                            <a4j:support action="#{ManagedActividadesProgramaproduccion.fechas_change1}" reRender="horasHombre" onsubmit="if(this.value.length<5){return false;}" event="onkeyup" />
                                        </h:inputText>
                                    </rich:column--%>
                                    <%--inicio ale unidades medida--%>
                                    <rich:column>
                                        <f:facet name="header">
                                            <h:outputText value="Fecha Inicio" styleClass="outputText2" />
                                        </f:facet>
                                        <h:inputText value="#{data.fechaInicio}" styleClass="inputText" size="10" onkeyup="calcularDiferenciaFechas(this)">
                                            <f:convertDateTime pattern="dd/MM/yyyy"/>
                                          </h:inputText>
                                        <h:inputText value="#{data.horaInicio}" styleClass="inputText" size="5" onkeyup="calcularDiferenciaFechas(this)">
                                            <f:convertDateTime pattern="HH:mm"/>
                                        </h:inputText>
                                    </rich:column>
                                    <rich:column>
                                        <f:facet name="header">
                                            <h:outputText value="Fecha Final" styleClass="outputText2" />
                                        </f:facet>
                                        <h:inputText value="#{data.fechaFinal}" styleClass="inputText" size ="10" onkeyup="calcularDiferenciaFechas(this)">
                                            <f:convertDateTime pattern="dd/MM/yyyy"/>

                                        </h:inputText>
                                        <h:inputText value="#{data.horaFinal}" styleClass="inputText" size ="5" onkeyup="calcularDiferenciaFechas(this)">
                                            <f:convertDateTime pattern="HH:mm"/>

                                        </h:inputText>
                                    </rich:column>
                                    <%--final ale unidades medida--%>
                        </rich:dataTable>
                        <br/>
                        <a4j:commandLink action="#{ManagedActividadesProgramaproduccion.adicionarPersonal_action}" reRender="listadoIngresosAcond" oncomplete="if(#{ManagedActividadesProgramaproduccion.seguimientoProgramaProduccion.habilitado==false}){deshabilitarPrimeraFecha('form2:listadoIngresosAcond')}" timeout="7200"  >
                            <h:graphicImage url="../img/mas.png"/>
                        </a4j:commandLink>
                        <a4j:commandLink action="#{ManagedActividadesProgramaproduccion.eliminarPersonal_action}" reRender="listadoIngresosAcond" oncomplete="if(#{ManagedActividadesProgramaproduccion.seguimientoProgramaProduccion.habilitado==false}){deshabilitarPrimeraFecha('form2:listadoIngresosAcond')}" timeout="7200">
                            <h:graphicImage url="../img/menos.png"/>
                        </a4j:commandLink>

                        <br/>

                        <%--a4j:commandButton styleClass="btn" value="Registrar"
                                            onclick="Richfaces.showModalPanel('panelAgregarSeguimientoProgramaProduccionPersonal')"
                                            action="#{ManagedActividadesProgramaproduccion.registrarSeguimientoProgramaProduccionPersonal_action}"
                                           reRender="contenidoAgregarSeguimientoProgramaProduccionPersonal" />
                         <a4j:commandButton styleClass="btn" value="Editar"
                                            onclick="Richfaces.showModalPanel('panelEditarSeguimientoProgramaProduccionPersonal')"
                                            action="#{ManagedActividadesProgramaproduccion.editarSeguimientoProgramaProduccionPersonal_action}"
                                           reRender="contenidoEditarSeguimientoProgramaProduccionPersonal" />
                        <a4j:commandButton styleClass="btn" value="Eliminar"
                        action="#{ManagedActividadesProgramaproduccion.eliminarSeguimientoProgramaProduccionPersonal_action}"
                                           reRender="contenidoSeguimientoProgramaProduccionPersonal" />
                        <a4j:commandButton styleClass="btn" value="Aceptar"
                                           onclick="Richfaces.hideModalPanel('panelSeguimientoProgramaProduccionPersonal')"
                                           action="#{ManagedActividadesProgramaproduccion.aceptarSeguimientoProgramaProduccionPersonal_action}"
                                           reRender="actividadesFormulaMaestra" oncomplete="sumaTotales('form1:actividadesFormulaMaestra')"/--%>
                        <a4j:commandButton styleClass="btn" value="Guardar" action="#{ManagedActividadesProgramaproduccion.guardarSeguimientoProgramaProduccionPersonal1_action}"
                        reRender="actividadesFormulaMaestra,listadoIngresosAcond" oncomplete="if(#{ManagedActividadesProgramaproduccion.mensaje eq 'guardadoCorrectamente'}){alert('Se registro el seguimiento correctamente');Richfaces.hideModalPanel('panelSeguimientoProgramaProduccionPersonal');sumaTotales('form1:actividadesFormulaMaestra')}"
                        timeout="7200"/>
                        <input onclick="Richfaces.hideModalPanel('panelSeguimientoProgramaProduccionPersonal')" type="button" class="btn" value="Cancelar" />


                        
                        
                        </div>
                        </h:panelGroup>
                        </a4j:form>
         </rich:modalPanel>

        <rich:modalPanel id="panelAgregarSeguimientoProgramaProduccionPersonal" minHeight="200"  minWidth="400"
                        height="200" width="400"  zindex="200"  headerClass="headerClassACliente"
                                     resizeable="false" >
                        <f:facet name="header">
                            <h:outputText value="Agregar Seguimiento"/>
                        </f:facet>
                        <a4j:form id="form3">
                            <h:panelGrid id="contenidoAgregarSeguimientoProgramaProduccionPersonal" columns="2" >
                                <h:outputText value="Personal :" styleClass="outputText1" />
                                <h:selectOneMenu value="#{ManagedActividadesProgramaproduccion.seguimientoProgramaProduccionPersonal.personal.codPersonal}" styleClass="inputText" >
                                    <f:selectItems value="#{ManagedActividadesProgramaproduccion.personalList}" />
                                </h:selectOneMenu>
                                <h:outputText value="Fecha Inicio :" styleClass="outputText1" />
                                <h:inputText  value="#{ManagedActividadesProgramaproduccion.seguimientoProgramaProduccionPersonal.fechaInicio}" styleClass="inputText" size="20" id="fechaInicial">
                                        <f:convertDateTime pattern="dd/MM/yyyy HH:mm" />
                                        <a4j:support event="onblur" action="#{ManagedActividadesProgramaproduccion.fechas_change}" oncomplete="valFecha1(document.getElementById('form3:fechaInicial'));" reRender="horasHombre" />
                                </h:inputText>
                                <h:inputText  value="#{ManagedActividadesProgramaproduccion.seguimientoProgramaProduccionPersonal.horaInicio}" styleClass="inputText" size="20" id="horaInicial">
                                        <f:convertDateTime pattern="dd/MM/yyyy HH:mm" />
                                        <a4j:support event="onblur" action="#{ManagedActividadesProgramaproduccion.fechas_change}" oncomplete="valFecha1(document.getElementById('form3:fechaInicial'));" reRender="horasHombre" />
                                </h:inputText>
                                <h:outputText value="Fecha Final :" styleClass="outputText1" />
                                <h:inputText  value="#{ManagedActividadesProgramaproduccion.seguimientoProgramaProduccionPersonal.fechaFinal}"   styleClass="inputText" size="20" id="fechaFinal" >
                                        <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                                        <a4j:support event="onblur" action="#{ManagedActividadesProgramaproduccion.fechas_change}" oncomplete="valFecha1(document.getElementById('form3:fechaFinal'));" reRender="horasHombre" />
                                </h:inputText>
                                <h:inputText  value="#{ManagedActividadesProgramaproduccion.seguimientoProgramaProduccionPersonal.horaFinal}"   styleClass="inputText" size="20" id="horaFinal" >
                                        <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                                        <a4j:support event="onblur" action="#{ManagedActividadesProgramaproduccion.fechas_change}" oncomplete="valFecha1(document.getElementById('form3:fechaFinal'));" reRender="horasHombre" />
                                </h:inputText>
                                <h:outputText value="Horas Hombre :" styleClass="outputText1" />
                            <h:outputText value="#{ManagedActividadesProgramaproduccion.seguimientoProgramaProduccionPersonal.horasHombre}" styleClass="outputText1" id="horasHombre">
                                <f:convertNumber pattern="###.00" locale="en" />
                            </h:outputText>
                            
                                <h:outputText value="Unidades Producidas :" styleClass="outputText1" />
                                <h:inputText value="#{ManagedActividadesProgramaproduccion.seguimientoProgramaProduccionPersonal.unidadesProducidas}" styleClass="inputText" />
                                
                            </h:panelGrid>

                                

                        <br/>
                        <div align="center">
                        <a4j:commandButton styleClass="btn" value="Guardar"
                                           onclick="Richfaces.hideModalPanel('panelAgregarSeguimientoProgramaProduccionPersonal')"
                                           action="#{ManagedActividadesProgramaproduccion.guardarSeguimientoProgramaProduccionPersonal_action}"
                                           reRender="contenidoSeguimientoProgramaProduccionPersonal" />
                         <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelAgregarSeguimientoProgramaProduccionPersonal')" class="btn" />
                        
                        </div>

                            
                        </a4j:form>
         </rich:modalPanel>

        <rich:modalPanel id="panelEditarSeguimientoProgramaProduccionPersonal" minHeight="200"  minWidth="400"
                        height="200" width="400"  zindex="200"  headerClass="headerClassACliente"
                                     resizeable="false" >
                        <f:facet name="header">
                            <h:outputText value="Agregar Seguimiento"/>
                        </f:facet>
                        <a4j:form id="form4">
                            <h:panelGrid id="contenidoEditarSeguimientoProgramaProduccionPersonal" columns="2" >
                                <h:outputText value="Personal :" styleClass="outputText1" />
                                <h:selectOneMenu value="#{ManagedActividadesProgramaproduccion.seguimientoProgramaProduccionPersonal.personal.codPersonal}" styleClass="inputText" >
                                    <f:selectItems value="#{ManagedActividadesProgramaproduccion.personalList}" />
                                </h:selectOneMenu>
                                <h:outputText value="Fecha Inicio :" styleClass="outputText1" />
                                <h:inputText  value="#{ManagedActividadesProgramaproduccion.seguimientoProgramaProduccionPersonal.fechaInicio}" styleClass="inputText" size="20" id="fechaInicial">
                                        <f:convertDateTime pattern="dd/MM/yyyy HH:mm" />
                                        <a4j:support event="onblur" action="#{ManagedActividadesProgramaproduccion.fechas_change}" oncomplete="valFecha1(document.getElementById('form4:fechaInicial'));" reRender="horasHombre" />
                                </h:inputText>
                                <h:outputText value="Fecha Final :" styleClass="outputText1" />
                                <h:inputText  value="#{ManagedActividadesProgramaproduccion.seguimientoProgramaProduccionPersonal.fechaFinal}"   styleClass="inputText" size="20" id="fechaFinal" >
                                        <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                                        <a4j:support event="onblur" action="#{ManagedActividadesProgramaproduccion.fechas_change}" oncomplete="valFecha1(document.getElementById('form4:fechaFinal'));" reRender="horasHombre" />
                                </h:inputText>
                                <h:outputText value="Horas Hombre :" styleClass="outputText1" />
                            <h:outputText value="#{ManagedActividadesProgramaproduccion.seguimientoProgramaProduccionPersonal.horasHombre}" styleClass="outputText1" id="horasHombre">
                                <f:convertNumber pattern="###.00" locale="en" />
                            </h:outputText>
                            
                                <h:outputText value="Unidades Producidas :" styleClass="outputText1" />
                                <h:inputText value="#{ManagedActividadesProgramaproduccion.seguimientoProgramaProduccionPersonal.unidadesProducidas}" styleClass="inputText" />
                                </h:panelGrid>



                        <br/>
                        <div align="center">
                        <a4j:commandButton styleClass="btn" value="Guardar"
                                           onclick="Richfaces.hideModalPanel('panelEditarSeguimientoProgramaProduccionPersonal')"
                                           action="#{ManagedActividadesProgramaproduccion.guardarEditarSeguimientoProgramaProduccion_action}"
                                           reRender="contenidoSeguimientoProgramaProduccionPersonal" />
                         <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelEditarSeguimientoProgramaProduccionPersonal')" class="btn" />

                        </div>


                        </a4j:form>
         </rich:modalPanel>
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

