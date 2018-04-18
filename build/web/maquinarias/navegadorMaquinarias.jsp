<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>
    
    <html>
        <head>
            <title>Maquinarias</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <link rel="STYLESHEET" type="text/css" href="../css/icons.css" />
            <script type="text/javascript" src="../js/general.js" ></script> 
            <script>
            </script>
        </head>
        <body >
            <h:form id="form1">               
                <div align="center">
                    <h:outputText value="#{ManagedMaquinaria.cargarMaquinariasList}"/>
                    <h:outputText styleClass="outputTextTituloSistema"  value="Listado de Maquinarias" />                    
                    <rich:panel headerClass="headerClassACliente">
                        <f:facet name="header">
                            <h:outputText value="Listado de Maquinarias"/>
                        </f:facet>
                        <h:panelGrid columns="6">
                            <h:outputText value="Nombre" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:inputText value="#{ManagedMaquinaria.maquinariaBuscar.nombreMaquina}" style="width:30 em" styleClass="inputText"/>
                            <h:outputText value="Código" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:inputText value="#{ManagedMaquinaria.maquinariaBuscar.codigo}" styleClass="inputText"/>
                            <h:outputText value="Area Empresa" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedMaquinaria.maquinariaBuscar.areasEmpresa.codAreaEmpresa}" styleClass="inputText">
                                <f:selectItem itemLabel="--Todos--" itemValue="0"/>
                                <f:selectItems value="#{ManagedMaquinaria.areasEmpresaSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Tipo Equipo" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedMaquinaria.maquinariaBuscar.tiposEquiposMaquinaria.codTipoEquipo}" styleClass="inputText">
                                <f:selectItem itemLabel="--Todos--" itemValue="0"/>
                                <f:selectItems value="#{ManagedMaquinaria.tiposEquipoSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Estado" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:selectOneMenu value="#{ManagedMaquinaria.maquinariaBuscar.estadoReferencial.codEstadoRegistro}" styleClass="inputText">
                                <f:selectItem itemLabel="--Todos--" itemValue="0"/>
                                <f:selectItem itemLabel="Activo" itemValue="1"/>
                                <f:selectItem itemLabel="No Activo" itemValue="2"/>
                            </h:selectOneMenu>
                        </h:panelGrid>
                        <a4j:commandLink styleClass="btn" action="#{ManagedMaquinaria.buscarMaquinarias_action}"
                                           reRender="dataMaquinarias">
                            <h:outputText styleClass="icon-search"/>
                            <h:outputText value="BUSCAR"/>
                        </a4j:commandLink>
                    </rich:panel>
                    <br>
                    <rich:dataTable value="#{ManagedMaquinaria.maquinariasList}" var="data" 
                                    id="dataMaquinarias" style="margin-top:1 em;top:1 em"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    binding="#{ManagedMaquinaria.maquinariaDataTable}"
                                    headerClass="headerClassACliente" >
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column>
                                    <h:outputText value=""/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="CODIGO"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="NOMBRE"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="FECHA COMPRA"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="TIPO DE MAQUINARIA"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="MARCA"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="AREA EMPRESA"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="ESTADO"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="OBSERVACION"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="MATERIAL ASOCIADO"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="PARTES MAQUINARIA"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        <rich:column>
                            <h:selectBooleanCheckbox value="#{data.checked}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.codigo}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.nombreMaquina}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.fechaCompra}" rendered="#{data.fechaCompra != null}">
                                <f:convertDateTime pattern="dd/MM/yyyy"/>
                            </h:outputText>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.tiposEquiposMaquinaria.nombreTipoEquipo}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.marcaMaquinaria.nombreMarcaMaquinaria}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.areasEmpresa.nombreAreaEmpresa}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.estadoReferencial.nombreEstadoRegistro}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.obsMaquina}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.materiales.nombreMaterial}"/>
                        </rich:column>
                        <rich:column styleClass="tdCenter">
                            <a4j:commandLink action="#{ManagedMaquinaria.seleccionarMaquinaria_action}"
                                             oncomplete="window.location.href='partesMaquinaria/navegadorPartesMaquinaria.jsf?data='+(new Date()).getTime().toString();">
                                <h:graphicImage url="../img/folder_32.png"/>
                            </a4j:commandLink>
                            
                        </rich:column>
                    </rich:dataTable>
                    </br>
                    <div id="bottonesAcccion" class="barraBotones">
                        <a4j:commandButton value="Agregar" onclick="window.location.href='agregarMaquinaria.jsf?data='+(new Date()).getTime().toString()"
                                           styleClass="btn"/>
                        <a4j:commandLink onclick="if(!editarItem('form1:dataMaquinarias')){return false;}"
                                           action="#{ManagedMaquinaria.editarMaquinaria_action}"
                                           oncomplete="window.location.href='editarMaquinaria.jsf?data='+(new Date()).getTime().toString()"
                                           styleClass="btn">
                            <h:outputText styleClass="icon-pencil2"/>
                            <h:outputText value="Editar"/>
                        </a4j:commandLink>
                        <a4j:commandLink onclick="if(!editarItem('form1:dataMaquinarias')){return false;}"
                                           action="#{ManagedMaquinaria.eliminarMaquinaria_action}"
                                           oncomplete="if(#{ManagedMaquinaria.mensaje eq '1'}){alert('Se elimino la maquinaria');}else{alert('#{ManagedMaquinaria.mensaje}');}"
                                           reRender="dataMaquinarias" styleClass="btn">
                            <h:outputText styleClass="icon-bin"/>
                            <h:outputText value="Eliminar"/>
                        </a4j:commandLink>
                    </div>
                    </div>
                    <br>
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

