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
            <h:outputText value="#{ManagedProductosDesarrolloVersion.cargarAgregarComponentesProdVersion}"/>
            <rich:panel headerClass="headerClassACliente" style="width:80%" id="contenidoEditar">
                <f:facet name="header">
                    <h:outputText value="Agregar Producto"/>
                </f:facet>
                <h:panelGrid columns="3">
                    <h:outputText value="Nro. Versión" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:outputText value="#{ManagedProductosDesarrolloVersion.componentesProdVersion.nroVersion}" styleClass="outputText2"/>
                    <h:outputText value="Producto Semi-Elaborado" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:selectOneRadio value="#{ManagedProductosDesarrolloVersion.componentesProdVersion.productoSemiterminado}"
                                      styleClass="outputText2" id="isProductoSemiterminado">
                        <f:selectItem itemValue='true' itemLabel="SI"/>
                        <f:selectItem itemValue='false' itemLabel="NO"/>
                        <a4j:support event="onclick" reRender="contenidoEditar"/>
                    </h:selectOneRadio>
                    <h:outputText value="Nombre Comercial" styleClass="outputTextBold" rendered="#{!ManagedProductosDesarrolloVersion.componentesProdVersion.productoSemiterminado}"/>
                    <h:outputText value="::" styleClass="outputTextBold" rendered="#{!ManagedProductosDesarrolloVersion.componentesProdVersion.productoSemiterminado}"/>
                    <h:panelGroup rendered="#{!ManagedProductosDesarrolloVersion.componentesProdVersion.productoSemiterminado}"
                                  id="contenidoNombreComercial">
                        <h:selectOneMenu value="#{ManagedProductosDesarrolloVersion.componentesProdVersion.producto.codProducto}"
                                         styleClass="inputText chosen">
                            <f:selectItems value="#{ManagedProductosDesarrolloVersion.productosSelectList}"/>
                        </h:selectOneMenu>
                        <a4j:commandButton value="Agregar Nuevo" styleClass="btn"
                                           action="#{ManagedProductosDesarrolloVersion.agregarNuevoProductoAction()}"
                                           reRender="contenidoCrearNuevoProducto"
                                           oncomplete="Richfaces.showModalPanel('panelCrearNuevoProducto')"/>
                    </h:panelGroup>

                    <h:outputText value="Forma Farmaceútica" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:selectOneMenu value="#{ManagedProductosDesarrolloVersion.componentesProdVersion.forma.codForma}" styleClass="inputText chosen">
                        <f:selectItems value="#{ManagedProductosDesarrolloVersion.formasFarmaceuticasSelectList}"/>
                    </h:selectOneMenu>
                    <h:outputText value="Sabor" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:selectOneMenu value="#{ManagedProductosDesarrolloVersion.componentesProdVersion.saboresProductos.codSabor}" styleClass="inputText chosen">
                        <f:selectItem itemLabel="--Ninguno--" itemValue="0"/>
                        <f:selectItems value="#{ManagedProductosDesarrolloVersion.saboresProductosSelectList}"/>
                    </h:selectOneMenu>
                    <h:outputText value="Condición de Venta" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:selectOneMenu value="#{ManagedProductosDesarrolloVersion.componentesProdVersion.condicionesVentasProducto.codCondicionVentaProducto}" styleClass="inputText">
                        <f:selectItem itemValue='0' itemLabel="--No Aplica--"/>
                        <f:selectItems value="#{ManagedProductosDesarrolloVersion.condicionesVentaProductoSelectList}"/>
                    </h:selectOneMenu>
                    
                    <h:outputText value="Presentaciones Registradas" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:inputTextarea value="#{ManagedProductosDesarrolloVersion.componentesProdVersion.presentacionesRegistradasRs}" styleClass="inputText" style="width:100%" cols="4"/>
                    
                    <h:outputText value="Registro Sanitario" styleClass="outputTextBold" rendered="#{!ManagedProductosDesarrolloVersion.componentesProdVersion.productoSemiterminado}"/>
                    <h:outputText value="::" styleClass="outputTextBold" rendered="#{!ManagedProductosDesarrolloVersion.componentesProdVersion.productoSemiterminado}"/>
                    <h:panelGroup rendered="#{!ManagedProductosDesarrolloVersion.componentesProdVersion.productoSemiterminado}">
                        <h:inputText value="#{ManagedProductosDesarrolloVersion.componentesProdVersion.regSanitario}" 
                                     styleClass="inputText" style="width:100%" id="regSanitario" 
                                     required="#{(not empty param['form1:btnGuardar'])}"
                                     requiredMessage="El registro sanitario no puede estar vacio" />
                        <h:message for="regSanitario" styleClass="message"/>
                    </h:panelGroup>
                    
                    <h:outputText value="Fecha Vencimiento" styleClass="outputTextBold" rendered="#{!ManagedProductosDesarrolloVersion.componentesProdVersion.productoSemiterminado}"/>
                    <h:outputText value="::" styleClass="outputTextBold" rendered="#{!ManagedProductosDesarrolloVersion.componentesProdVersion.productoSemiterminado}"/>
                    <h:panelGroup rendered="#{!ManagedProductosDesarrolloVersion.componentesProdVersion.productoSemiterminado}">
                        <rich:calendar value="#{ManagedProductosDesarrolloVersion.componentesProdVersion.fechaVencimientoRS}" styleClass="inputText"
                                       datePattern="dd/MM/yyyy" id="fechaVencimientoRs" 
                                       required="#{(not empty param['form1:btnGuardar'])}"
                                       requiredMessage="La fecha de vencimiento no puede estar vacia">
                        </rich:calendar>
                        <h:message for="fechaVencimientoRs" styleClass="message"/>
                    </h:panelGroup>
                    
                    <h:outputText value="Vida Util" styleClass="outputTextBold" id="vidadUtil" rendered="#{!ManagedProductosDesarrolloVersion.componentesProdVersion.productoSemiterminado}"/>
                    <h:outputText value="::" styleClass="outputTextBold" rendered="#{!ManagedProductosDesarrolloVersion.componentesProdVersion.productoSemiterminado}"/>
                    <h:panelGroup rendered="#{!ManagedProductosDesarrolloVersion.componentesProdVersion.productoSemiterminado}">
                        <h:inputText value="#{ManagedProductosDesarrolloVersion.componentesProdVersion.vidaUtil}"
                                     required="true"
                                     requiredMessage="Debe registrar la vida util del producto"
                                     converterMessage="Debe registrar un dato entero"
                                     styleClass="inputText" style="width:8em" id="vidaUtil" onkeypress="valNum(event);">
                            <f:validator validatorId="validatorDoubleRange"/>
                            <f:attribute name="minimum" value="12"/>
                            <f:attribute name="disable" value="#{(empty param['form1:btnGuardar'])}"/>
                        </h:inputText>
                        <h:outputText value="(meses)" styleClass="outputTextBold"/>
                        <h:message for="vidaUtil" styleClass="message"/>
                    </h:panelGroup>
                    
                    <h:outputText value="Nombre Genérico/Concentración" styleClass="outputTextBold" rendered="#{!ManagedProductosDesarrolloVersion.componentesProdVersion.productoSemiterminado}"/>
                    <h:outputText value="::" styleClass="outputTextBold" rendered="#{!ManagedProductosDesarrolloVersion.componentesProdVersion.productoSemiterminado}"/>
                    <h:outputText value="#{ManagedProductosDesarrolloVersion.componentesProdVersion.concentracionEnvasePrimario}" id="concentracionProducto" styleClass="outputText2" rendered="#{!ManagedProductosDesarrolloVersion.componentesProdVersion.productoSemiterminado}"/>
                    </h:panelGrid>
                    
                        <rich:dataTable value="#{ManagedProductosDesarrolloVersion.componentesProdVersion.componentesProdConcentracionList}" 
                                        var="data" id="dataMaterialesConcentracion"
                                        rowKeyVar="index"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    rendered="#{!ManagedProductosDesarrolloVersion.componentesProdVersion.productoSemiterminado}"
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';"
                                    headerClass="headerClassACliente" columnClasses="tituloCampo">
                            <f:facet name="header">
                                <rich:columnGroup>
                                    <rich:column colspan="11">
                                        <h:outputText value="Concentracion para :  "/>
                                        <h:panelGroup>
                                            <h:inputText value="#{ManagedProductosDesarrolloVersion.componentesProdConcentracionBean.unidadProducto}" styleClass="inputText" 
                                                         required="#{!(empty param['form1:btnGuardar'])}"
                                                         requiredMessage="El dato no puede estar vacio"
                                                         id="unidadMedidadProducto" onkeyup="generarConcentracion();"/>
                                            <h:message for="unidadMedidadProducto" styleClass="message"/>
                                        </h:panelGroup>
                                    </rich:column>
                                    <rich:column breakBefore="true">
                                        <h:outputText value="Nombre Genérico"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Nombre Material"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Cantidad"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Unidad Medida"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Material Equivalencia"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Cantidad Equivalente"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Unidad Medida"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Excipiente"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Peso Molecular"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Tipo de Referencia"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Eliminar"/>
                                    </rich:column>
                                </rich:columnGroup>
                            </f:facet>
                                 <rich:column>
                                     <h:outputText value="#{data.materiales.nombreCCC}" styleClass="outputText2"/>
                                 </rich:column>
                                 <rich:column >
                                     <h:outputText value="#{data.materiales.nombreMaterial}" styleClass="outputText2"/>
                                 </rich:column >
                                 <rich:column >
                                     <h:inputText value="#{data.cantidad}" size="6"  id="cantidadMaterialConcentracion"
                                                  onkeypress="valNum(event);" onkeyup="generarConcentracion()" styleClass="inputText">
                                        <f:validator validatorId="validatorDoubleRange"/>
                                        <f:attribute name="minimum" value="0.01"/>
                                        <f:attribute name="disable" value="#{(empty param['form1:btnGuardar'])}"/>
                                     </h:inputText>
                                     <h:message for="cantidadMaterialConcentracion" styleClass="message"/>
                                 </rich:column >
                                 <rich:column >
                                     <h:selectOneMenu  onchange="generarConcentracion()" value="#{data.unidadesMedida.codUnidadMedida}" styleClass="inputText">
                                         <f:selectItems value="#{ManagedProductosDesarrolloVersion.unidadesMedidaSelectList}"/>
                                     </h:selectOneMenu>
                                 </rich:column >
                                 <rich:column >
                                     <h:inputText value="#{data.nombreMaterialEquivalencia}" styleClass="inputText" onkeyup="generarConcentracion();"/>
                                 </rich:column >
                                 <rich:column >
                                     <h:inputText size="6" value="#{data.cantidadEquivalencia}" onkeypress="valNum(event)" onblur="valorPorDefecto(this);validarMayorIgualACero(this);" onkeyup="generarConcentracion();" styleClass="inputText"/>
                                 </rich:column >
                                 <rich:column >
                                     <h:selectOneMenu  onchange="generarConcentracion()" value="#{data.unidadMedidaEquivalencia.codUnidadMedida}" styleClass="inputText">
                                         <f:selectItems value="#{ManagedProductosDesarrolloVersion.unidadesMedidaSelectList}"/>
                                     </h:selectOneMenu>
                                 </rich:column >
                                 <rich:column >
                                     <h:selectBooleanCheckbox value="#{data.excipiente}" onclick="generarConcentracion()"/>
                                 </rich:column >
                                <rich:column>
                                    <h:inputText value="#{data.pesoMolecular}" size="5" styleClass="inputText"/>
                                </rich:column>
                                <rich:column>
                                    <h:selectOneMenu value="#{data.tiposReferenciaCc.codReferenciaCc}" styleClass="inputText">
                                        <f:selectItems value="#{ManagedProductosDesarrolloVersion.tiposReferenciaCcSelect}"/>
                                    </h:selectOneMenu>
                                </rich:column>
                                <rich:column>
                                    <a4j:commandButton value="Eliminar" styleClass="btn"
                                                       action="#{ManagedProductosDesarrolloVersion.eliminarComponentesProdConcetracionAction(index)}"
                                                       reRender="dataMaterialesConcentracion"/>
                                </rich:column>
                                 <f:facet name="footer">
                                     <rich:columnGroup>
                                        <rich:column colspan="11" styleClass="tdCenter">
                                            <a4j:commandButton value="Agregar Material" styleClass="btn"
                                                    reRender="contenidoAgregarMaterialConcentracion"
                                                    oncomplete="Richfaces.showModalPanel('panelAgregarMaterialConcentracion')"/>
                                        </rich:column>
                                     </rich:columnGroup>
                                 </f:facet> 
                         </rich:dataTable>
                        <h:inputHidden value="#{ManagedProductosDesarrolloVersion.componentesProdVersion.concentracionEnvasePrimario}" id="concentracionInput"/>
                        <a4j:commandButton id="btnGuardar" 
                                       reRender="contenidoEditar" value="Guardar" 
                                       action="#{ManagedProductosDesarrolloVersion.guardarComponentesProdVersionAction()}" styleClass="btn"
                                       oncomplete="if('#{facesContext.maximumSeverity}'.length == 0){if(#{ManagedProductosDesarrolloVersion.mensaje eq '1'}){alert('Se guardo la edición de la version'); redireccionar('navegadorProductosDesarrollo.jsf');}else{alert('#{ManagedProductosDesarrolloVersion.mensaje}')}}"/>
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





