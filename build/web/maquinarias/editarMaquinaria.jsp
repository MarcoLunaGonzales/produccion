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
            <link rel="STYLESHEET" type="text/css" href="../css/icons.css" />
            <script type="text/javascript" src="../js/general.js" ></script> 
            <script>
                function validarRegistro()
                {
                    return(validarRegistroNoVacio(document.getElementById("form1:codigo"))&&validarRegistroNoVacio(document.getElementById("form1:nombreMaquinaria")));
                }
            </script>
        </head>
        <body >
            <h:form id="form1">               
                <div align="center">
                    <h:outputText styleClass="outputTextTituloSistema"  value="Edición de Maquinaria" />                    
                    <rich:panel headerClass="headerClassACliente" style="width:80%">
                        <f:facet name="header">
                            <h:outputText value="Editar Maquinaria"/>
                        </f:facet>
                        <h:panelGrid columns="3">
                            <h:outputText value="Nombre" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:inputText value="#{ManagedMaquinaria.maquinariaEditar.nombreMaquina}" id="nombreMaquinaria" style="width:40 em" styleClass="inputText"/>
                            <h:outputText value="Código" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:inputText value="#{ManagedMaquinaria.maquinariaEditar.codigo}" id="codigo" style="width:100%" styleClass="inputText"/>
                            <h:outputText value="Area" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedMaquinaria.maquinariaEditar.areasEmpresa.codAreaEmpresa}" styleClass="inputText">
                                <f:selectItems value="#{ManagedMaquinaria.areasEmpresaSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Tipo Equipo" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedMaquinaria.maquinariaEditar.tiposEquiposMaquinaria.codTipoEquipo}" styleClass="inputText">
                                <f:selectItems value="#{ManagedMaquinaria.tiposEquipoSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Marca" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedMaquinaria.maquinariaEditar.marcaMaquinaria.codMarcaMaquinaria}" styleClass="inputText">
                                <f:selectItem itemValue='0' itemLabel="--No Aplica--"/>
                                <f:selectItems value="#{ManagedMaquinaria.marcasMaquinariaSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Material Asociado Almacen" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedMaquinaria.maquinariaEditar.materiales.codMaterial}" styleClass="inputText">
                                <f:selectItem itemValue='0' itemLabel="--No Aplica--"/>
                                <f:selectItems value="#{ManagedMaquinaria.materialesSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Fecha Compra" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <rich:calendar  datePattern="dd/MM/yyyy" value="#{ManagedMaquinaria.maquinariaEditar.fechaCompra}" id="fechaCompra" enableManualInput="true"   />
                            <h:outputText value="Descripción" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:inputTextarea value="#{ManagedMaquinaria.maquinariaEditar.obsMaquina}" styleClass="inputText" rows="4" style="width:100%">
                            </h:inputTextarea>
                            <h:outputText value="Estado" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedMaquinaria.maquinariaEditar.estadoReferencial.codEstadoRegistro}" styleClass="inputText">
                                <f:selectItem itemValue="1" itemLabel="Activo"/>
                                <f:selectItem itemValue="2" itemLabel="No Activo"/>
                            </h:selectOneMenu>
                        </h:panelGrid>
                        <a4j:commandLink onclick="if(!validarRegistro()){return false;}" styleClass="btn" action="#{ManagedMaquinaria.guardarEdicionMaquinaria_action}"
                                           oncomplete="if(#{ManagedMaquinaria.mensaje eq '1'}){alert('Se guardo la edición de la maquinaria');redireccionar('navegadorMaquinarias.jsf');}
                                           else{alert('#{ManagedMaquinaria.mensaje}');}">
                            <h:outputText styleClass="icon-floppy-disk"/>
                            <h:outputText value="Guardar"/>
                        </a4j:commandLink>
                        <a4j:commandButton value="Cancelar" styleClass="btn" oncomplete="window.location.href='navegadorMaquinarias.jsf?cancel'+(new Date()).getTime().toString()"
                                           reRender="dataMaquinarias"/>
                    </rich:panel>
                    
                    </div>
                    
                </div>
                
            </h:form>
            <a4j:status id="statusPeticion"
                        onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                        onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
            </a4j:status>

            <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                             minWidth="200" height="80" width="400" zindex="100" onshow="window.focus();">

                <div align="center">
                    <h:graphicImage value="../img/load2.gif" />
                </div>
            </rich:modalPanel>
        </body>
    </html>
    
</f:view>

