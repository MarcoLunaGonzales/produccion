<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>

<html>
    <head>
        <title>SISTEMA</title>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <link rel="STYLESHEET" type="text/css" href="../css/chosen.css" />
        <script type="text/javascript" src="../js/general.js"></script>
        <script type="text/javascript">

                    function focusRed(celda)
                    {
                        celda.focus();
                        celda.style.backgroundColor='rgb(255, 182, 193)';
                    }
                    function formarNombre(){

                        var nombreProducto=document.getElementById('form1:producto');
                        var nombreProductoSem=nombreProducto.options[nombreProducto.selectedIndex].text;
                        var productosFormasFar=document.getElementById('form1:productosFormasFar');
                        var nombreProductoSem1=productosFormasFar.options[productosFormasFar.selectedIndex].text;
                        //var cantidadPeso=document.getElementById('form1:volumenPesoPresentacion');
                        //alert(cantidadPeso.value);
                        var nombreProductoSemiterminado=document.getElementById('form1:nombreProductoSemiterminado');
                        nombreProductoSemiterminado.value=nombreProductoSem+" "+nombreProductoSem1;//+" "+cantidadPeso.value;

                    }
                    function generarConcentracion()
                    {
                        var tabla=document.getElementById("form1:dataMaterialesConcentracion").getElementsByTagName("tbody")[0];
                        var concentracion="";
                        for(var i=0 ; i<tabla.rows.length ; i++)
                        {
                            if(!tabla.rows[i].cells[7].getElementsByTagName("input")[0].checked)
                            {
                                var select=tabla.rows[i].cells[3].getElementsByTagName("select")[0];
                                concentracion+=(concentracion==""?"":",")+tabla.rows[i].cells[0].getElementsByTagName("span")[0].innerHTML+
                                                " "+tabla.rows[i].cells[2].getElementsByTagName("input")[0].value+" "+
                                                (parseInt(select.value)>0?select.options[select.selectedIndex].innerHTML:"");
                                var select2=tabla.rows[i].cells[6].getElementsByTagName("select")[0];
                                concentracion+=(parseFloat(tabla.rows[i].cells[5].getElementsByTagName("input")[0].value)>0?
                                                " equivalente a "+tabla.rows[i].cells[4].getElementsByTagName("input")[0].value+" "+
                                                tabla.rows[i].cells[5].getElementsByTagName("input")[0].value+" "+
                                                (parseInt(select2.value)>0?select2.options[select2.selectedIndex].innerHTML:""):"");
                            }

                        }
                        document.getElementById("form1:concentracionProducto").innerHTML=concentracion+"/"+document.getElementById("form1:dataMaterialesConcentracion:unidadMedidadProducto").value;
                    }
    </script>
    <style type="text/css">
        .multiple{
            color:white;
            background-color:#aaaaaa;
            font-weight:bold;
            font-size:14px;
        }
    </style>
</head>
<body >
    <f:view>
    <a4j:form id="form1"  >
        <center>
            <h:outputText value="#{ManagedProductosDesarrolloVersion.cargarEdicionComponentesProdVersion}"/>
            <rich:panel headerClass="headerClassACliente" style="width:80%" id="contenidoEditar">
                <f:facet name="header">
                    <h:outputText value="Edición de Producto"/>
                </f:facet>
                <h:panelGrid columns="3">
                    <h:outputText value="Nro. Versión" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:outputText value="#{ManagedProductosDesarrolloVersion.componentesProdVersion.nroVersion}" styleClass="outputText2"/>
                    <h:outputText value="Nombre Producto" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:panelGroup>
                        <h:inputText value="#{ManagedProductosDesarrolloVersion.componentesProdVersion.nombreProdSemiterminado}" 
                                     styleClass="inputText" style="width:25em" 
                                     required="#{(not empty param['form1:btnGuardar'])}"
                                     requiredMessage="Debe registrar el nombre del producto"
                                     id="nombreProdSemiterminado"/>
                        <h:message for="nombreProdSemiterminado" styleClass="message"/>
                    </h:panelGroup>
                    <h:outputText value="Area de fabricación" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:selectOneMenu value="#{ManagedProductosDesarrolloVersion.componentesProdVersion.areasEmpresa.codAreaEmpresa}" styleClass="inputText">
                        <f:selectItems value="#{ManagedProductosDesarrolloVersion.areasFabricacionProductoSelectList}"/>
                        <a4j:support event="onchange" reRender="panelDT"/>
                    </h:selectOneMenu>
                    <h:outputText value="Via Administración" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:selectOneMenu value="#{ManagedProductosDesarrolloVersion.componentesProdVersion.viasAdministracionProducto.codViaAdministracionProducto}" styleClass="inputText">
                        <f:selectItems value="#{ManagedProductosDesarrolloVersion.viasAdministracionSelectList}"/>
                    </h:selectOneMenu>
                    <h:outputText value="Unidad Medida Volumen" styleClass="outputTextBold" rendered="#{ManagedProductosDesarrolloVersion.componentesProdVersion.areasEmpresa.codAreaEmpresa eq '80'||ManagedProductosDesarrolloVersion.componentesProdVersion.areasEmpresa.codAreaEmpresa eq '81'}"/>
                    <h:outputText value="::" styleClass="outputTextBold" rendered="#{ManagedProductosDesarrolloVersion.componentesProdVersion.areasEmpresa.codAreaEmpresa eq '80'||ManagedProductosDesarrolloVersion.componentesProdVersion.areasEmpresa.codAreaEmpresa eq '81'}"/>
                    <h:selectOneMenu style="margin-left:0.2em" value="#{ManagedProductosDesarrolloVersion.componentesProdVersion.unidadMedidaVolumen.codUnidadMedida}" styleClass="inputText" rendered="#{ManagedProductosDesarrolloVersion.componentesProdVersion.areasEmpresa.codAreaEmpresa eq '80'||ManagedProductosDesarrolloVersion.componentesProdVersion.areasEmpresa.codAreaEmpresa eq '81'}">
                        <f:selectItems value="#{ManagedProductosDesarrolloVersion.unidadesMedidaSelectList}"/>
                    </h:selectOneMenu>
                    <h:outputText value="Volumen envase primario" styleClass="outputTextBold" rendered="#{ManagedProductosDesarrolloVersion.componentesProdVersion.areasEmpresa.codAreaEmpresa eq '80'||ManagedProductosDesarrolloVersion.componentesProdVersion.areasEmpresa.codAreaEmpresa eq '81'}"/>
                    <h:outputText value="::" styleClass="outputTextBold" rendered="#{ManagedProductosDesarrolloVersion.componentesProdVersion.areasEmpresa.codAreaEmpresa eq '80'||ManagedProductosDesarrolloVersion.componentesProdVersion.areasEmpresa.codAreaEmpresa eq '81'}"/>
                    <h:panelGroup rendered="#{ManagedProductosDesarrolloVersion.componentesProdVersion.areasEmpresa.codAreaEmpresa eq '80'||ManagedProductosDesarrolloVersion.componentesProdVersion.areasEmpresa.codAreaEmpresa eq '81'}">
                        <h:inputText size="20" value="#{ManagedProductosDesarrolloVersion.componentesProdVersion.cantidadVolumen}"
                                     styleClass="inputText" id="cantidadVolumen" onkeypress="valNum();" 
                                     required="#{(not empty param['form1:btnGuardar'])}"
                                     converterMessage="Debe registrar un numero">
                            <f:validator validatorId="validatorDoubleRange"/>
                            <f:attribute name="minimum" value="0.1"/>
                            <f:attribute name="disable" value="#{(empty param['form1:btnGuardar'])}"/>
                        </h:inputText>
                        <h:message for="cantidadVolumen" styleClass="message"/>
                    </h:panelGroup>
                    <h:outputText value="Volumen de dosificado" styleClass="outputTextBold" rendered="#{ManagedProductosDesarrolloVersion.componentesProdVersion.areasEmpresa.codAreaEmpresa eq '81'}"/>
                    <h:outputText value="::" styleClass="outputTextBold" rendered="#{ManagedProductosDesarrolloVersion.componentesProdVersion.areasEmpresa.codAreaEmpresa eq '81'}"/>
                    <h:panelGroup rendered="#{ManagedProductosDesarrolloVersion.componentesProdVersion.areasEmpresa.codAreaEmpresa eq '81'}">
                        <h:inputText size="10" required="#{(not empty param['form1:btnGuardar'])}"
                                     requiredMessage="Debe registrar el volument de dosicado"
                                     converterMessage="Debe registrar un numero"
                                     value="#{ManagedProductosDesarrolloVersion.componentesProdVersion.cantidadVolumenDeDosificado}" 
                                     styleClass="inputText" id="cantidadVolumenDosificado" onkeypress="valNum();">
                            <f:validator validatorId="validatorDoubleRange"/>
                            <f:attribute name="minimum" value="0.1"/>
                            <f:attribute name="disable" value="#{(empty param['form1:btnGuardar'])}"/>
                        </h:inputText>
                        <h:message for="cantidadVolumenDosificado" styleClass="message"/>
                    </h:panelGroup>

                    <h:outputText value="Tolerancia a Fabricar" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:panelGroup>
                        <h:inputText value="#{ManagedProductosDesarrolloVersion.componentesProdVersion.toleranciaVolumenfabricar}" onkeypress="valNum();" styleClass="inputText" style="width:5em"/>
                        <h:outputText value="(%)" styleClass="outputTextBold"/>
                    </h:panelGroup>
                    <h:outputText value="Peso Teórico del Producto" styleClass="outputTextBold" rendered="#{ManagedProductosDesarrolloVersion.componentesProdVersion.areasEmpresa.codAreaEmpresa eq '95'||ManagedProductosDesarrolloVersion.componentesProdVersion.areasEmpresa.codAreaEmpresa eq '82'}"/>
                    <h:outputText value="::" styleClass="outputTextBold" rendered="#{ManagedProductosDesarrolloVersion.componentesProdVersion.areasEmpresa.codAreaEmpresa eq '95'||ManagedProductosDesarrolloVersion.componentesProdVersion.areasEmpresa.codAreaEmpresa eq '82'}"/>
                    <h:panelGrid columns="2" rendered="#{ManagedProductosDesarrolloVersion.componentesProdVersion.areasEmpresa.codAreaEmpresa eq '95'||ManagedProductosDesarrolloVersion.componentesProdVersion.areasEmpresa.codAreaEmpresa eq '82'}">
                        <h:panelGroup>
                            <h:inputText value="#{ManagedProductosDesarrolloVersion.componentesProdVersion.pesoTeorico}"
                                         id="cantidadpesoTeorico" requiredMessage="Debe registrar el peso del producto"
                                         styleClass="inputText"
                                         required="#{(not empty param['form1:btnGuardar'])}"
                                         converterMessage="Debe registrar un numero">
                                <f:validator validatorId="validatorDoubleRange"/>
                                <f:attribute name="minimum" value="0.1"/>
                                <f:attribute name="disable" value="#{(empty param['form1:btnGuardar'])}"/>
                            </h:inputText>
                            <h:message for="cantidadpesoTeorico" styleClass="message"/>
                        </h:panelGroup>
                        <h:selectOneMenu style="margin-left:0.2em"
                                         value="#{ManagedProductosDesarrolloVersion.componentesProdVersion.unidadMedidaPesoTeorico.codUnidadMedida}" 
                                         styleClass="inputText">
                            <f:selectItems value="#{ManagedProductosDesarrolloVersion.unidadesMedidaSelectList}"/>
                        </h:selectOneMenu>

                    </h:panelGrid>
                    <h:outputText value="Limite de Alerta(%)" styleClass="outputTextBold" rendered="#{ManagedProductosDesarrolloVersion.componentesProdVersion.areasEmpresa.codAreaEmpresa eq '95'||ManagedProductosDesarrolloVersion.componentesProdVersion.areasEmpresa.codAreaEmpresa eq '82'}"/>
                    <h:outputText value="::" styleClass="outputTextBold" rendered="#{ManagedProductosDesarrolloVersion.componentesProdVersion.areasEmpresa.codAreaEmpresa eq '95'||ManagedProductosDesarrolloVersion.componentesProdVersion.areasEmpresa.codAreaEmpresa eq '82'}"/>
                    <h:panelGroup rendered="#{ManagedProductosDesarrolloVersion.componentesProdVersion.areasEmpresa.codAreaEmpresa eq '95'||ManagedProductosDesarrolloVersion.componentesProdVersion.areasEmpresa.codAreaEmpresa eq '82'}">
                        <h:inputText value="#{ManagedProductosDesarrolloVersion.componentesProdVersion.porcientoLimiteAlerta}"
                                    id="limiteAlerta" requiredMessage="Debe registrar el limite de alerta"
                                    styleClass="inputText"
                                    required="#{(not empty param['form1:btnGuardar'])}"
                                    converterMessage="Debe registrar un numero">
                            <f:validator validatorId="validatorDoubleRange"/>
                            <f:attribute name="minimum" value="0.1"/>
                            <f:attribute name="disable" value="#{(empty param['form1:btnGuardar'])}"/>
                        </h:inputText>
                        <h:message for="limiteAlerta" styleClass="message"/>
                    </h:panelGroup>
                    <h:outputText value="Limite de Acción(%)" styleClass="outputTextBold" rendered="#{ManagedProductosDesarrolloVersion.componentesProdVersion.areasEmpresa.codAreaEmpresa eq '95'||ManagedProductosDesarrolloVersion.componentesProdVersion.areasEmpresa.codAreaEmpresa eq '82'}"/>
                    <h:outputText value="::" styleClass="outputTextBold" rendered="#{ManagedProductosDesarrolloVersion.componentesProdVersion.areasEmpresa.codAreaEmpresa eq '95'||ManagedProductosDesarrolloVersion.componentesProdVersion.areasEmpresa.codAreaEmpresa eq '82'}"/>
                    <h:panelGroup rendered="#{ManagedProductosDesarrolloVersion.componentesProdVersion.areasEmpresa.codAreaEmpresa eq '95'||ManagedProductosDesarrolloVersion.componentesProdVersion.areasEmpresa.codAreaEmpresa eq '82'}">
                        <h:inputText value="#{ManagedProductosDesarrolloVersion.componentesProdVersion.porcientoLimiteAccion}"
                                    id="limiteAccion" requiredMessage="Debe registrar el limite de acción"
                                    styleClass="inputText"
                                    required="#{(not empty param['form1:btnGuardar'])}"
                                    converterMessage="Debe registrar un numero">
                            <f:validator validatorId="validatorDoubleRange"/>
                            <f:attribute name="minimum" value="0.1"/>
                            <f:attribute name="disable" value="#{(empty param['form1:btnGuardar'])}"/>
                        </h:inputText>
                        <h:message for="limiteAccion" styleClass="message"/>
                    </h:panelGroup>
                    <h:outputText value="Color Presentación Primaria" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:selectOneMenu value="#{ManagedProductosDesarrolloVersion.componentesProdVersion.coloresPresentacion.codColor}" 
                                     styleClass="inputText">
                        <f:selectItem itemLabel="--Ninguno--" itemValue="0" />
                        <f:selectItems value="#{ManagedProductosDesarrolloVersion.coloresPresPrimSelectList}"/>
                    </h:selectOneMenu>
                    <h:outputText value="Tamaño Capsula" styleClass="outputTextBold" rendered="#{ManagedProductosDesarrolloVersion.componentesProdVersion.forma.codForma eq '6'}"/>
                    <h:outputText value="::" styleClass="outputTextBold" rendered="#{ManagedProductosDesarrolloVersion.componentesProdVersion.forma.codForma eq '6'}"/>
                    <h:selectOneMenu value="#{ManagedProductosDesarrolloVersion.componentesProdVersion.tamaniosCapsulasProduccion.codTamanioCapsulaProduccion}" styleClass="inputText"
                    rendered="#{ManagedProductosDesarrolloVersion.componentesProdVersion.forma.codForma eq '6'}">
                        <f:selectItem itemValue='0' itemLabel="--Ninguno--"/>
                        <f:selectItems value="#{ManagedProductosDesarrolloVersion.tamaniosCapsulasSelectList}"/>
                    </h:selectOneMenu>
                    <h:outputText value="Tamaño Lote" styleClass="outputTextBold" />
                    <h:outputText value="::" styleClass="outputTextBold" />
                    <h:panelGroup>
                        <h:inputText value="#{ManagedProductosDesarrolloVersion.componentesProdVersion.tamanioLoteProduccion}" 
                                     required="#{(not empty param['form1:btnGuardar'])}" converterMessage="Debe registrar un numero entero" 
                                     id="cantidadLote"
                                     onkeypress="valNum();" styleClass="inputText">
                            <f:validator validatorId="validatorDoubleRange"/>
                            <f:attribute name="minimum" value="1"/>
                            <f:attribute name="disable" value="#{(empty param['form1:btnGuardar'])}"/>
                        </h:inputText>
                        <h:message for="cantidadLote" styleClass="message"/>
                    </h:panelGroup>
                    <h:outputText value="Estado" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:selectOneMenu value="#{ManagedProductosDesarrolloVersion.componentesProdVersion.estadoCompProd.codEstadoCompProd}" styleClass="inputText">
                        <f:selectItem itemValue="1" itemLabel="Activo"/>
                        <f:selectItem itemValue="2" itemLabel="Discontinuado"/>
                    </h:selectOneMenu>
                    <h:outputText value="Aplica Especificaciones Físicas" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:selectBooleanCheckbox value="#{ManagedProductosDesarrolloVersion.componentesProdVersion.aplicaEspecificacionesFisicas}"/>
                    <h:outputText value="Aplica Especificaciones Químicas" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:selectBooleanCheckbox value="#{ManagedProductosDesarrolloVersion.componentesProdVersion.aplicaEspecificacionesQuimicas}"/>
                    <h:outputText value="Aplica Especificaciones Microbiologicas" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:selectBooleanCheckbox value="#{ManagedProductosDesarrolloVersion.componentesProdVersion.aplicaEspecificacionesMicrobiologicas}"/>
                </h:panelGrid>
                    
                        
                        <h:inputHidden value="#{ManagedProductosDesarrolloVersion.componentesProdVersion.concentracionEnvasePrimario}" id="concentracionInput"/>
                        <a4j:commandButton id="btnGuardar" 
                                       reRender="contenidoEditar" value="Guardar" 
                                       action="#{ManagedProductosDesarrolloVersion.editarComponentesProdVersionAction()}" styleClass="btn"
                                       oncomplete="if('#{facesContext.maximumSeverity}'.length == 0){if(#{ManagedProductosDesarrolloVersion.mensaje eq '1'}){alert('Se guardo la edición de la version'); redireccionar('navegadorProductosDesarrolloEnsayos.jsf');}else{alert('#{ManagedProductosDesarrolloVersion.mensaje}')}}"/>
                        <a4j:commandButton value="Cancelar" oncomplete="redireccionar('navegadorProductosDesarrolloEnsayos.jsf');" styleClass="btn"/>
                </rich:panel>
                     
                    
        </center>
        
    </a4j:form>
    <rich:modalPanel id="panelAgregarMaterialConcentracion"  minHeight="173"  minWidth="420"
                        height="350" width="550"
                        zindex="50"
                        headerClass="headerClassACliente"
                        resizeable="false" style="overflow :auto" >
        <f:facet name="header">
            <h:outputText value="<center>Agregar Material a concentración</center>" escape="false"/>
        </f:facet>
        <a4j:form>
            <center>
           <h:panelGroup id="contenidoAgregarMaterialConcentracion">
               <rich:panel headerClass="headerClassACliente">
                   <f:facet name="header">
                       <h:outputText value="Buscador"/>
                   </f:facet>
                    <h:panelGrid columns="6" style="width:100%">
                         <h:outputText value="Nombre Material" styleClass="outputTextBold"/>
                         <h:outputText value="::" styleClass="outputTextBold"/>
                         <h:panelGroup>
                             <h:inputText value="#{ManagedProductosDesarrolloVersion.materialesBuscar.nombreMaterial}" styleClass="inputText"/>
                         </h:panelGroup>
                         <h:outputText value="Nombre Generico" styleClass="outputTextBold"/>
                         <h:outputText value="::" styleClass="outputTextBold"/>
                         <h:panelGroup>
                             <h:inputText value="#{ManagedProductosDesarrolloVersion.materialesBuscar.nombreCCC}" styleClass="inputText"/>
                         </h:panelGroup>
                    </h:panelGrid>
                   <a4j:commandButton value="Buscar" action="#{ManagedProductosDesarrolloVersion.buscarMaterialAction()}"
                                      styleClass="btn"
                                      reRender="dataMaterial"/>
                </rich:panel>
               <div style="width:100%;height:150px;overflow-y: auto">
                <rich:dataTable value="#{ManagedProductosDesarrolloVersion.materialesList}"
                                id="dataMaterial" styleClass="margin-top:8px"
                                headerClass="headerClassACliente" var="material">
                    <f:facet name="header">
                        <rich:columnGroup>
                             <rich:column>
                                 <h:outputText value="Seleccionar"/>
                             </rich:column>
                             <rich:column>
                                 <h:outputText value="Nombre"/>
                             </rich:column>
                             <rich:column>
                                 <h:outputText value="Nombre Generico"/>
                             </rich:column>
                        </rich:columnGroup>
                    </f:facet>
                     <rich:column>
                         <a4j:commandButton value="Seleccionar" action="#{ManagedProductosDesarrolloVersion.seleccionarAgregarMaterialConcentracionAction()}"
                                            reRender="dataMaterialesConcentracion" styleClass="btn" oncomplete="Richfaces.hideModalPanel('panelAgregarMaterialConcentracion');generarConcentracion();">
                             <f:setPropertyActionListener value="#{material}" target="#{ManagedProductosDesarrolloVersion.materiales}"/>
                         </a4j:commandButton>
                     </rich:column>
                    <rich:column>
                         <h:outputText value="#{material.nombreMaterial}"/>
                     </rich:column>
                     <rich:column>
                         <h:outputText value="#{material.nombreCCC}"/>
                     </rich:column>
                </rich:dataTable>
               </div>
           </h:panelGroup>  
           <a4j:commandButton value="Cancelar" styleClass="btn"
                                oncomplete="Richfaces.hideModalPanel('panelAgregarMaterialConcentracion')"/>
            </center>
        </a4j:form>
    </rich:modalPanel>
    
    <rich:modalPanel id="panelCrearNuevoProducto"  minHeight="173"  minWidth="420"
                        height="150" width="450"
                        zindex="50"
                        headerClass="headerClassACliente"
                        resizeable="false" style="overflow :auto" >
        <f:facet name="header">
            <h:outputText value="<center>Crear Nombre Comercial</center>" escape="false"/>
        </f:facet>
        <a4j:form>
            <center>
           <h:panelGroup id="contenidoCrearNuevoProducto">
               <h:panelGrid columns="3" style="width:100%">
                    <h:outputText value="Nombre" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:panelGroup>
                        <h:inputText value="#{ManagedProductosDesarrolloVersion.producto.nombreProducto}"
                                     style="width:100%" onkeyup="valInputMay(this)"
                                     id="nombreProducto"
                                     required="true"
                                     requiredMessage="Debe registrar el nombre"/>
                        <h:message styleClass="message" for="nombreProducto"/>
                    </h:panelGroup>
               </h:panelGrid>
           </h:panelGroup>
            <br/>
            <a4j:commandButton value="Guardar" oncomplete="if('#{facesContext.maximumSeverity}'.length == 0){Richfaces.hideModalPanel('panelCrearNuevoProducto');}"
                               reRender="contenidoCrearNuevoProducto,contenidoEditar"
                               action="#{ManagedProductosDesarrolloVersion.guardarProductoAction()}"
                                styleClass="btn"/>
            <a4j:commandButton value="Cancelar" styleClass="btn"
                                oncomplete="Richfaces.hideModalPanel('panelCrearNuevoProducto')"/>
            </center>
        </a4j:form>
    </rich:modalPanel>
    <a4j:include viewId="/panelProgreso.jsp"/>
    
    </f:view>
</body>
</html>





