<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
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
                function validarRegistro()
                {
                    if(document.getElementById("form1:isProductoSemiterminado:1").checked)
                    {

                        if(!validarRegistroNoVacioById("form1:unidadMedidadProducto"))
                        {
                            return false;
                        }
                        var tabla=document.getElementById("form1:dataMaterialesConcentracion").getElementsByTagName("tbody")[0];
                        if(tabla.rows.length == 0)
                        {
                             alert('Debe registrar los materiales de la concentracion');
                             return false;
                        }
                    }       
                    return true;
                }
                function generarConcentracion(){
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
                function generarConcentracionActivado(input)
                {
                    generarConcentracion();
                }
                function validarFecha(celda)
                {
                    if(celda.value!='')
                    {
                        if(!valFecha(celda))
                        {
                            celda.focus();
                            celda.style.backgroundColor='rgb(255, 182, 193)';
                        }
                    }
                }
                function mostrarOcultarConcentracion()
                {
                    document.getElementById("tablaConcentracion").style.display=(document.getElementById("form1:isProductoSemiterminado:1").checked?'':'none');
                }
        </script>
        <style>
            .multiple{
                color:white;
                background-color:#aaaaaa;
                font-weight:bold;
                font-size:14px;
            }
        </style>
</head>
<body >
    
    <a4j:form id="form1"  >
        <center>
            <h:outputText value="#{ManagedComponentesProdVersion.cargarAgregarComponentesProdVersionNuevo}"/>
            <rich:panel headerClass="headerClassACliente" style="width:80%" id="formAgregar">
                <f:facet name="header">
                    <h:outputText value="Agregar Nuevo Producto"/>
                </f:facet>
                <h:panelGrid columns="3" rendered="#{ManagedComponentesProdVersion.controlRegistroSanitario}" id="panelAgregar">
                    <h:outputText value="Producto Semi-Elaborado" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:selectOneRadio value="#{ManagedComponentesProdVersion.componentesProdVersionNuevo.productoSemiterminado}" styleClass="outputText2"
                        id="isProductoSemiterminado" >
                        <f:selectItem itemValue='true' itemLabel="SI"/>
                        <f:selectItem itemValue='false' itemLabel="NO"/>
                        <a4j:support event="onclick" reRender="panelAgregar,formAgregar"/>
                    </h:selectOneRadio>

                    <h:outputText value="Nombre Comercial" styleClass="outputTextBold" rendered="#{!ManagedComponentesProdVersion.componentesProdVersionNuevo.productoSemiterminado}"/>
                    <h:outputText value="::" styleClass="outputTextBold" rendered="#{!ManagedComponentesProdVersion.componentesProdVersionNuevo.productoSemiterminado}"/>
                    <h:panelGroup rendered="#{!ManagedComponentesProdVersion.componentesProdVersionNuevo.productoSemiterminado}">
                        <h:selectOneMenu value="#{ManagedComponentesProdVersion.componentesProdVersionNuevo.producto.codProducto}"
                                         id="codProducto"
                                         styleClass="inputText">
                            <f:selectItems value="#{ManagedComponentesProdVersion.productosSelectList}"/>
                        </h:selectOneMenu>
                        <a4j:commandButton value="Agregar Nuevo" styleClass="btn"
                                           action="#{ManagedComponentesProdVersion.agregarNuevoProductoAction}"
                                           reRender="contenidoCrearNuevoProducto"
                                           oncomplete="Richfaces.showModalPanel('panelCrearNuevoProducto')"/>
                    </h:panelGroup>
                    <h:outputText value="Tipo Modificación Producto" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:selectOneMenu value="#{ManagedComponentesProdVersion.componentesProdVersionNuevo.tiposModificacionProducto.codTipoModificacionProducto}" styleClass="inputText">
                        <f:selectItems value="#{ManagedComponentesProdVersion.tiposModificacionProductoSelectList}"/>
                    </h:selectOneMenu>                
                    <h:outputText value="Forma Farmaceútica" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:selectOneMenu value="#{ManagedComponentesProdVersion.componentesProdVersionNuevo.forma.codForma}" styleClass="inputText">
                        <f:selectItems value="#{ManagedComponentesProdVersion.formasFarmaceuticasSelectList}"/>
                    </h:selectOneMenu>
                    <h:outputText value="Sabor" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:selectOneMenu value="#{ManagedComponentesProdVersion.componentesProdVersionNuevo.saboresProductos.codSabor}" styleClass="inputText">
                        <f:selectItem itemLabel="--Ninguno--" itemValue="0"/>
                        <f:selectItems value="#{ManagedComponentesProdVersion.saboresProductoSelectList}"/>
                    </h:selectOneMenu>
                    <h:outputText value="Condición de Venta" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:selectOneMenu value="#{ManagedComponentesProdVersion.componentesProdVersionNuevo.condicionesVentasProducto.codCondicionVentaProducto}" styleClass="inputText">
                        <f:selectItems value="#{ManagedComponentesProdVersion.condicionesVentasSelectList}"/>
                    </h:selectOneMenu>
                    <h:outputText value="Presentaciones Registradas" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:inputTextarea value="#{ManagedComponentesProdVersion.componentesProdVersionNuevo.presentacionesRegistradasRs}" styleClass="inputText" style="width:100%" cols="4"/>
                    <h:outputText value="Registro Sanitario" styleClass="outputTextBold" rendered="#{!ManagedComponentesProdVersion.componentesProdVersionNuevo.productoSemiterminado}"/>
                    <h:outputText value="::" styleClass="outputTextBold" rendered="#{!ManagedComponentesProdVersion.componentesProdVersionNuevo.productoSemiterminado}"/>
                    <h:inputText value="#{ManagedComponentesProdVersion.componentesProdVersionNuevo.regSanitario}" styleClass="inputText" style="width:100%" id="regSanitario" rendered="#{!ManagedComponentesProdVersion.componentesProdVersionNuevo.productoSemiterminado}"/>
                    <h:outputText value="Fecha Vencimiento" styleClass="outputTextBold" rendered="#{!ManagedComponentesProdVersion.componentesProdVersionNuevo.productoSemiterminado}"/>
                    <h:outputText value="::" styleClass="outputTextBold" rendered="#{!ManagedComponentesProdVersion.componentesProdVersionNuevo.productoSemiterminado}"/>
                    <h:inputText value="#{ManagedComponentesProdVersion.componentesProdVersionNuevo.fechaVencimientoRS}" onblur="validarFecha(this)" styleClass="inputText" style="width:10em" id="fechaVencimientoRs" rendered="#{!ManagedComponentesProdVersion.componentesProdVersionNuevo.productoSemiterminado}">
                        <f:convertDateTime pattern="dd/MM/yyyy"/>
                    </h:inputText>
                    <h:outputText value="Vida Util" styleClass="outputTextBold" id="vidadUtil" rendered="#{!ManagedComponentesProdVersion.componentesProdVersionNuevo.productoSemiterminado}"/>
                    <h:outputText value="::" styleClass="outputTextBold" rendered="#{!ManagedComponentesProdVersion.componentesProdVersionNuevo.productoSemiterminado}"/>
                    <h:panelGroup rendered="#{!ManagedComponentesProdVersion.componentesProdVersionNuevo.productoSemiterminado}">
                        <h:inputText value="#{ManagedComponentesProdVersion.componentesProdVersionNuevo.vidaUtil}"
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

                    <h:outputText value="Nombre Genérico/Concentración" styleClass="outputTextBold" rendered="#{!ManagedComponentesProdVersion.componentesProdVersionNuevo.productoSemiterminado}"/>
                    <h:outputText value="::" styleClass="outputTextBold" rendered="#{!ManagedComponentesProdVersion.componentesProdVersionNuevo.productoSemiterminado}"/>
                    <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionNuevo.concentracionEnvasePrimario}" id="concentracionProducto" styleClass="outputText2" rendered="#{!ManagedComponentesProdVersion.componentesProdVersionNuevo.productoSemiterminado}"/>
                </h:panelGrid>
                <rich:dataTable value="#{ManagedComponentesProdVersion.componentesProdVersionNuevo.componentesProdConcentracionList}"
                            var="data" id="dataMaterialesConcentracion"
                            onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                            rendered="#{!ManagedComponentesProdVersion.componentesProdVersionNuevo.productoSemiterminado}"
                            onRowMouseOver="this.style.backgroundColor='#F3F7FD';"
                            headerClass="headerClassACliente" columnClasses="tituloCampo">
                    <f:facet name="header">
                        <rich:columnGroup>
                            <rich:column colspan="9">
                                <h:outputText value="Concentracion para :  "/>
                                <h:inputText value="#{ManagedComponentesProdVersion.componentesProdConcentracionBean.unidadProducto}" rendered="#{ManagedComponentesProdVersion.controlRegistroSanitario}" styleClass="inputText" 
                                             required="#{(not empty param['form1:btnGuardar'])}"
                                             requiredMessage="El dato no puede estar vacio"
                                             id="unidadMedidadProducto" onkeyup="generarConcentracion();"/>
                                <h:message for="unidadMedidadProducto" styleClass="message"/>
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
                                 <f:selectItems value="#{ManagedComponentesProdVersion.unidadesMedidaSelectList}"/>
                             </h:selectOneMenu>
                         </rich:column >
                         <rich:column>
                             <h:inputText value="#{data.nombreMaterialEquivalencia}" styleClass="inputText" onkeyup="generarConcentracion();"/>
                         </rich:column>
                         <rich:column>
                             <h:inputText size="6" value="#{data.cantidadEquivalencia}" onkeypress="valNum(event)" onblur="valorPorDefecto(this);validarMayorIgualACero(this);" onkeyup="generarConcentracion();" styleClass="inputText"/>
                         </rich:column>
                         <rich:column>
                             <h:selectOneMenu  onchange="generarConcentracion()" value="#{data.unidadMedidaEquivalencia.codUnidadMedida}" styleClass="inputText">
                                 <f:selectItems value="#{ManagedComponentesProdVersion.unidadesMedidaSelectList}"/>
                             </h:selectOneMenu>
                         </rich:column>
                         <rich:column>
                             <h:selectBooleanCheckbox value="#{data.excipiente}" onclick="generarConcentracion()"/>
                         </rich:column>
                        <rich:column>
                            <a4j:commandButton value="Eliminar" styleClass="btn"
                                            reRender="dataMaterialesConcentracion"
                                            actionListener="#{ManagedComponentesProdVersion.componentesProdVersionNuevo.componentesProdConcentracionList.remove(data)}"/>
                        </rich:column>
                    <f:facet name="footer">
                        <rich:columnGroup>
                            <rich:column colspan="9" styleClass="tdCenter">
                               <a4j:commandButton value="Agregar Material" styleClass="btn"
                                       reRender="contenidoAgregarMaterialConcentracion"
                                       oncomplete="Richfaces.showModalPanel('panelAgregarMaterialConcentracion')"/>
                           </rich:column>
                        </rich:columnGroup>
                    </f:facet> 
                </rich:dataTable>
                <a4j:commandButton value="Guardar"  onclick="if((!confirm('Esta seguro de crear un nuevo producto?'))||(!validarRegistro())){return false;}"
                                   id="btnGuardar"
                                   reRender="formAgregar"
                                    action="#{ManagedComponentesProdVersion.guardarNuevoComponenteProdVersion_action}" styleClass="btn"
                                    oncomplete="if('#{facesContext.maximumSeverity}'.length == 0){if(#{ManagedComponentesProdVersion.mensaje eq '1'}){alert('Se guardo el nuevo producto');window.location.href='navegadorNuevosComponentesProd.jsf?reg='+(new Date()).getTime().toString();}else{alert('#{ManagedComponentesProdVersion.mensaje}');}}"/>
                <a4j:commandButton value="Cancelar" oncomplete="window.location.href='navegadorNuevosComponentesProd.jsf?data='+(new Date()).getTime().toString();" styleClass="btn"/>
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
                             <h:inputText value="#{ManagedComponentesProdVersion.materialesBuscar.nombreMaterial}" styleClass="inputText"/>
                         </h:panelGroup>
                         <h:outputText value="Nombre Generico" styleClass="outputTextBold"/>
                         <h:outputText value="::" styleClass="outputTextBold"/>
                         <h:panelGroup>
                             <h:inputText value="#{ManagedComponentesProdVersion.materialesBuscar.nombreCCC}" styleClass="inputText"/>
                         </h:panelGroup>
                    </h:panelGrid>
                   <a4j:commandButton value="Buscar" action="#{ManagedComponentesProdVersion.buscarMaterialAction()}"
                                      styleClass="btn"
                                      reRender="dataMaterial"/>
                </rich:panel>
               <div style="width:100%;height:150px;overflow-y: auto">
                <rich:dataTable value="#{ManagedComponentesProdVersion.materialesList}"
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
                         <a4j:commandButton value="Seleccionar" action="#{ManagedComponentesProdVersion.seleccionarAgregarNuevoMaterialConcentracionAction()}"
                                            reRender="dataMaterialesConcentracion" styleClass="btn" oncomplete="Richfaces.hideModalPanel('panelAgregarMaterialConcentracion');generarConcentracion();">
                             <f:setPropertyActionListener value="#{material}" target="#{ManagedComponentesProdVersion.materiales}"/>
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
                        <h:inputText value="#{ManagedComponentesProdVersion.producto.nombreProducto}"
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
                               reRender="contenidoCrearNuevoProducto,panelAgregar"
                               action="#{ManagedComponentesProdVersion.guardarProductoNuevoComponentesProd()}"
                                styleClass="btn"/>
            <a4j:commandButton value="Cancelar" styleClass="btn"
                                oncomplete="Richfaces.hideModalPanel('panelCrearNuevoProducto')"/>
            </center>
        </a4j:form>
    </rich:modalPanel>
    <a4j:include viewId="/message.jsp"/>
    <a4j:include viewId="/panelProgreso.jsp"/>
    <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js" ></script>
</body>
</html>

</f:view>



