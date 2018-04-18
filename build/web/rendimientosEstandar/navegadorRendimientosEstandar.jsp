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
            <script type="text/javascript" src="../js/general.js" ></script>
            <link rel="STYLESHEET" type="text/css" href="../css/chosen.css" /> 
            
            <script type="text/javascript">
                function validarModificarRendimientoProducto()
                {
                    if(validarMayorACero(document.getElementById("formEditarp:rendimientoMinimo"))&&validarMayorACero(document.getElementById("formEditarp:rendimientoMaximo")))
                    {
                        if(parseFloat(document.getElementById("formEditarp:rendimientoMinimo").value)>parseFloat(document.getElementById("formEditarp:rendimientoMaximo").value))
                        {
                            mostrarMensajeHint('el rendimiento minimo tiene que ser menor rendimiento mayor',document.getElementById("formEditarp:rendimientoMinimo"));
                            return false;
                        }
                        else
                        {
                            return true;
                        }    
                        
                    }
                    else
                    {
                        return false;
                    }
                    return false;
                }
                function validarModificarRendimientoFormaFarmaceutica()
                {
                    if(validarMayorACero(document.getElementById("formEditarf:rendimientoMinimo"))&&validarMayorACero(document.getElementById("formEditarf:rendimientoMaximo")))
                    {
                        if(parseFloat(document.getElementById("formEditarf:rendimientoMinimo").value)>parseFloat(document.getElementById("formEditarf:rendimientoMaximo").value))
                        {
                            mostrarMensajeHint('el rendimiento minimo tiene que ser menor rendimiento mayor',document.getElementById("formEditarf:rendimientoMinimo"));
                            return false;
                        }
                        else
                        {
                            return true;
                        }    
                        
                    }
                    else
                    {
                        return false;
                    }
                    return false;
                }
                function validarRegistrarRendimientoFormaFarmaceutica()
                {
                    if(validarSeleccionMayorACero(document.getElementById("form4:codFormaFarmaceutica"))&&
                            validarMayorACero(document.getElementById("form4:rendimientoMinimo"))&&validarMayorACero(document.getElementById("form4:rendimientoMaximo")))
                    {
                        if(parseFloat(document.getElementById("form4:rendimientoMinimo").value)>parseFloat(document.getElementById("form4:rendimientoMaximo").value))
                        {
                            mostrarMensajeHint('el rendimiento minimo tiene que ser menor rendimiento mayor',document.getElementById("form4:rendimientoMinimo"));
                            return false;
                        }
                        else
                        {
                            return true;
                        }    
                        
                    }
                    else
                    {
                        return false;
                    }
                    return false;
                }
                function validarRegistrarRendimientoProducto()
                {//
                    if(validarSeleccionMayorACero(document.getElementById("form5:codProducto"))&&
                            validarMayorACero(document.getElementById("form5:rendimientoMinimo"))&&validarMayorACero(document.getElementById("form5:rendimientoMaximo")))
                    {
                        if(parseFloat(document.getElementById("form5:rendimientoMinimo").value)>parseFloat(document.getElementById("form5:rendimientoMaximo").value))
                        {
                            mostrarMensajeHint('el rendimiento minimo tiene que ser menor rendimiento mayor',document.getElementById("form5:rendimientoMinimo"));
                            return false;
                        }
                        else
                        {
                            return true;
                        }    
                        
                    }
                    else
                    {
                        return false;
                    }
                    return false;
                }
            </script>
        </head>
        <body >
          <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedRendimientoEstandarProductos.cargarRendimientoEstandar}"/>
                    <rich:dataTable value="#{ManagedRendimientoEstandarProductos.rendimientoEstandarFormaFarmaceuticaList}"
                                    var="data"
                                    id="dataRendimientoProductos"
                                    binding="#{ManagedRendimientoEstandarProductos.rendimientoEstandarFormaDataTable}"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" >
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column>
                                    <h:outputText value="Forma Farmaceutica<br><input type='text' onkeyup='buscarCeldaAgregar(this,0)' class='inputText'>" escape="false"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Fecha de Inicio rendimiento"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Rendimiento Mínimo"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Rendimiento Máximo"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Editar"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        <rich:column>
                            <h:outputText value="#{data.formasFarmaceuticas.nombreForma}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.fechaInicio}">
                                <f:convertDateTime pattern="dd/MM/yyyy HH:mm" locale="en"/>
                            </h:outputText>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.porcientoRendimientoMinimo}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.porcientoRendimientoMaximo}"/>
                        </rich:column>
                        <rich:column>
                            <a4j:commandLink action="#{ManagedRendimientoEstandarProductos.seleccionarEditarRendimientoEstandarForma}"
                                             reRender="contenidoEditarRendimientoEstandarForma"
                                             oncomplete="Richfaces.showModalPanel('panelEditarRendimientoEstandarForma')">
                                <h:outputText value="Editar"/>
                            </a4j:commandLink>
                        </rich:column>
                        
                    </rich:dataTable>
                    <br>
                    <a4j:commandButton value="Agregar" action="#{ManagedRendimientoEstandarProductos.cargarAgregarFormaFarmaceuticaAgregar}"
                                       reRender="contenidoRegistrarRendimientoEstandarForma"
                                       oncomplete="Richfaces.showModalPanel('panelRegistrarRendimientoEstandarForma')" styleClass="btn"/>
                    <br>   
                    <rich:dataTable value="#{ManagedRendimientoEstandarProductos.rendimientoEstandarComponentesProdList}"
                                    var="data" binding="#{ManagedRendimientoEstandarProductos.rendimientoEstandarProductoDataTable}"
                                    id="dataRendimientoEstandarProducto"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" >
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column>
                                    <h:outputText value="Producto<br><input type='text' onkeyup='buscarCeldaAgregar(this,0)' class='inputText'>" escape="false"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Tamaño Lote Producción"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Fecha de Inicio rendimiento"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Rendimiento Mínimo"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Rendimiento Máximo"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Editar"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        
                        <rich:column>
                            <h:outputText value="#{data.componentesProd.nombreProdSemiterminado}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.componentesProd.tamanioLoteProduccion}"/>
                        </rich:column>
                        
                        <rich:column>
                            <h:outputText value="#{data.fechaInicio}">
                                <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                            </h:outputText>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.porcientoRendimientoMinimo}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.porcientoRendimientoMaximo}"/>
                        </rich:column>
                        <rich:column>
                            <a4j:commandLink action="#{ManagedRendimientoEstandarProductos.seleccionarEditarRendimientoEstandarComponentesProd}"
                                            reRender="contenidoEditarRendimientoEstandarProducto"
                                            oncomplete="Richfaces.showModalPanel('panelEditarRendimientoEstandarProducto')">
                               <h:outputText value="Editar"/>
                           </a4j:commandLink>
                        </rich:column>
                    </rich:dataTable>   
                    <a4j:commandButton value="Agregar" action="#{ManagedRendimientoEstandarProductos.cargarAgregarComponentesProdAgregar}"
                                       reRender="contenidoRegistrarRendimientoEstandarProducto"
                                       oncomplete="Richfaces.showModalPanel('panelRegistrarRendimientoEstandarProducto')" styleClass="btn"/>  

                </div>

            </a4j:form>
            <rich:modalPanel id="panelEditarRendimientoEstandarProducto" minHeight="150"  minWidth="610"
                                     height="200" width="610"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="<center>Modificar Rendimiento de Producto</center>" escape="false"/>
                        </f:facet>
                        <a4j:form id="formEditarp">
                            <center>
                        <h:panelGroup id="contenidoEditarRendimientoEstandarProducto">
                          
                            <h:panelGrid columns="3">
                                <h:outputText styleClass="outputTextBold" value="Producto" />
                                <h:outputText styleClass="outputTextBold" value="::" />
                                <h:outputText styleClass="outputText2" value="#{ManagedRendimientoEstandarProductos.rendimientoEstandarComponentesProdEditar.componentesProd.nombreProdSemiterminado}" />
                                <h:outputText styleClass="outputTextBold" value="Tamaño Lote" />
                                <h:outputText styleClass="outputTextBold" value="::" />
                                <h:outputText styleClass="outputText2" value="#{ManagedRendimientoEstandarProductos.rendimientoEstandarComponentesProdEditar.componentesProd.tamanioLoteProduccion}" />
                                <h:outputText styleClass="outputTextBold" value="Rendimiento Mínimo(%)" />
                                <h:outputText styleClass="outputTextBold" value="::" />
                                <h:inputText id="rendimientoMinimo" value="#{ManagedRendimientoEstandarProductos.rendimientoEstandarComponentesProdEditar.porcientoRendimientoMinimo}" styleClass="inputText" onkeypress="valNum(event)"/>
                                <h:outputText styleClass="outputTextBold" value="Rendimiento Máximo(%)" />
                                <h:outputText styleClass="outputTextBold" value="::" />
                                <h:inputText id="rendimientoMaximo" value="#{ManagedRendimientoEstandarProductos.rendimientoEstandarComponentesProdEditar.porcientoRendimientoMaximo}" styleClass="inputText" onkeypress="valNum(event)"/>
                            </h:panelGrid>
                         
                                
                        </h:panelGroup>
                        <br>
                        <a4j:commandButton styleClass="btn" value="Guardar" onclick="if(!validarModificarRendimientoProducto()){return false;}"
                                          action="#{ManagedRendimientoEstandarProductos.guardarEditarRendimientoEstandarComponentesProd_action}"
                                          oncomplete="if(#{ManagedRendimientoEstandarProductos.mensaje eq '1'}){alert('se registro el rendimiento');Richfaces.hideModalPanel('panelEditarRendimientoEstandarProducto');}else{alert('#{ManagedRendimientoEstandarProductos.mensaje}')}" reRender="dataRendimientoEstandarProducto" />
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelEditarRendimientoEstandarProducto')" class="btn" />
                               </center>
                        </a4j:form>
                         
            </rich:modalPanel>
            <rich:modalPanel id="panelEditarRendimientoEstandarForma" minHeight="150"  minWidth="610"
                                     height="200" width="610"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="<center>Modificar Rendimiento de Forma Farmaceútica</center>" escape="false"/>
                        </f:facet>
                        <a4j:form id="formEditarf">
                            <center>
                        <h:panelGroup id="contenidoEditarRendimientoEstandarForma">
                          
                            <h:panelGrid columns="3">
                                <h:outputText styleClass="outputTextBold" value="Forma Farmaceútica" />
                                <h:outputText styleClass="outputTextBold" value="::" />
                                <h:outputText styleClass="outputText2" value="#{ManagedRendimientoEstandarProductos.rendimientoEstandarFormaFarmaceuticaEditar.formasFarmaceuticas.nombreForma}" />
                                <h:outputText styleClass="outputTextBold" value="Rendimiento Mínimo(%)" />
                                <h:outputText styleClass="outputTextBold" value="::" />
                                <h:inputText id="rendimientoMinimo" value="#{ManagedRendimientoEstandarProductos.rendimientoEstandarFormaFarmaceuticaEditar.porcientoRendimientoMinimo}" styleClass="inputText" onkeypress="valNum(even)"/>
                                <h:outputText styleClass="outputTextBold" value="Rendimiento Máximo(%)" />
                                <h:outputText styleClass="outputTextBold" value="::" />
                                <h:inputText id="rendimientoMaximo" value="#{ManagedRendimientoEstandarProductos.rendimientoEstandarFormaFarmaceuticaEditar.porcientoRendimientoMaximo}" styleClass="inputText" onkeypress="valNum(even)"/>
                            </h:panelGrid>
                         
                                
                        </h:panelGroup>
                        <br>
                        <a4j:commandButton styleClass="btn" value="Guardar" onclick="if(!validarModificarRendimientoFormaFarmaceutica()){return false;}"
                                          action="#{ManagedRendimientoEstandarProductos.guardarEditarRendimientoEstandarFormaFarmaceutica_action}"
                                          oncomplete="if(#{ManagedRendimientoEstandarProductos.mensaje eq '1'}){alert('se edito el rendimiento');Richfaces.hideModalPanel('panelEditarRendimientoEstandarForma');}else{alert('#{ManagedRendimientoEstandarProductos.mensaje}')}" reRender="dataRendimientoProductos" />
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelEditarRendimientoEstandarForma')" class="btn" />
                               </center>
                        </a4j:form>
                         
            </rich:modalPanel>
             <rich:modalPanel id="panelRegistrarRendimientoEstandarForma" minHeight="150"  minWidth="610"
                                     height="150" width="610"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="<center>Registrar Rendimiento de Forma Farmaceutica</center>" escape="false"/>
                        </f:facet>
                        <a4j:form id="form4">
                            <center>
                        <h:panelGroup id="contenidoRegistrarRendimientoEstandarForma">
                          
                            <h:panelGrid columns="3">
                                <h:outputText styleClass="outputTextBold" value="Forma Farmaceútica" />
                                <h:outputText styleClass="outputTextBold" value="::" />
                                <h:selectOneMenu id="codFormaFarmaceutica" value="#{ManagedRendimientoEstandarProductos.rendimientoEstandarFormaFarmaceuticaAgregar.formasFarmaceuticas.codForma}" styleClass="inputText">
                                    <f:selectItem itemValue="0" itemLabel="--Seleccione una opcion--"/>
                                    <f:selectItems value="#{ManagedRendimientoEstandarProductos.formasFarmaceuticasSelectList}"/>
                                </h:selectOneMenu>
                                <h:outputText styleClass="outputTextBold" value="Rendimiento Mínimo(%)" />
                                <h:outputText styleClass="outputTextBold" value="::" />
                                <h:inputText id="rendimientoMinimo" value="#{ManagedRendimientoEstandarProductos.rendimientoEstandarFormaFarmaceuticaAgregar.porcientoRendimientoMinimo}" styleClass="inputText" onkeypress="valNum(even)"/>
                                <h:outputText styleClass="outputTextBold" value="Rendimiento Máximo(%)" />
                                <h:outputText styleClass="outputTextBold" value="::" />
                                <h:inputText id="rendimientoMaximo" value="#{ManagedRendimientoEstandarProductos.rendimientoEstandarFormaFarmaceuticaAgregar.porcientoRendimientoMaximo}" styleClass="inputText" onkeypress="valNum(even)"/>
                            </h:panelGrid>
                         
                                
                        </h:panelGroup>
                        <br>
                        <a4j:commandButton styleClass="btn" value="Guardar" onclick="if(!validarRegistrarRendimientoFormaFarmaceutica()){return false;}"
                                          action="#{ManagedRendimientoEstandarProductos.guardarAgregarRendimientoEstandarFormaFarmaceutica_action}"
                                          oncomplete="if(#{ManagedRendimientoEstandarProductos.mensaje eq '1'}){alert('se registro el rendimiento');Richfaces.hideModalPanel('panelRegistrarRendimientoEstandarForma');}else{alert('#{ManagedRendimientoEstandarProductos.mensaje}')}" reRender="dataRendimientoProductos" />
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelRegistrarRendimientoEstandarForma')" class="btn" />
                               </center>
                        </a4j:form>
                         
            </rich:modalPanel>
            <rich:modalPanel id="panelRegistrarRendimientoEstandarProducto" minHeight="150"  minWidth="610"
                                     height="200" width="630"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="<center>Registro Rendimiento de Producto</center>" escape="false"/>
                        </f:facet>
                        <a4j:form id="form5">
                            <center>
                        <h:panelGroup id="contenidoRegistrarRendimientoEstandarProducto">
                          
                            <h:panelGrid columns="3">
                                <h:outputText styleClass="outputTextBold" value="Producto" />
                                <h:outputText styleClass="outputTextBold" value="::" />
                                <h:selectOneMenu id="codProducto" value="#{ManagedRendimientoEstandarProductos.rendimientoEstandarComponentesProdAgregar.componentesProd.codCompprod}" styleClass="chosen">
                                    <f:selectItem itemValue="0" itemLabel="--Seleccione una opcion--"/>
                                    <f:selectItems  value="#{ManagedRendimientoEstandarProductos.componentesProdSelectList}"/>
                                </h:selectOneMenu>
                                <h:outputText styleClass="outputTextBold" value="Rendimiento Mínimo(%)" />
                                <h:outputText styleClass="outputTextBold" value="::" />
                                <h:inputText id="rendimientoMinimo" value="#{ManagedRendimientoEstandarProductos.rendimientoEstandarComponentesProdAgregar.porcientoRendimientoMinimo}" styleClass="inputText" onkeypress="valNum(even)"/>
                                <h:outputText styleClass="outputTextBold" value="Rendimiento Máximo(%)" />
                                <h:outputText styleClass="outputTextBold" value="::" />
                                <h:inputText id="rendimientoMaximo" value="#{ManagedRendimientoEstandarProductos.rendimientoEstandarComponentesProdAgregar.porcientoRendimientoMaximo}" styleClass="inputText" onkeypress="valNum(even)"/>
                            </h:panelGrid>
                         
                                
                        </h:panelGroup>
                        <br>
                        <a4j:commandButton styleClass="btn" value="Guardar" onclick="if(!validarRegistrarRendimientoProducto()){return false;}"
                                          action="#{ManagedRendimientoEstandarProductos.guardarAgregarRendimientoEstandarComponentesProd_action}"
                                          oncomplete="if(#{ManagedRendimientoEstandarProductos.mensaje eq '1'}){alert('se registro el rendimiento');Richfaces.hideModalPanel('panelRegistrarRendimientoEstandarProducto');}else{alert('#{ManagedRendimientoEstandarProductos.mensaje}')}" reRender="dataRendimientoEstandarProducto" />
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelRegistrarRendimientoEstandarProducto')" class="btn" />
                               </center>
                        </a4j:form>
                         
            </rich:modalPanel>
            <a4j:status id="statusPeticion"
                        onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                        onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox');cargarChosen();">
            </a4j:status>

            <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                             minWidth="200" height="80" width="400" zindex="200" onshow="window.focus();">

                <div align="center">
                    <h:graphicImage value="../img/load2.gif" />
                </div>
            </rich:modalPanel>     
            <a4j:loadScript src="../js/chosen.js" />
            <script type="text/javascript">
                    cargarChosen();
            </script>
        </body>
    </html>

</f:view>

