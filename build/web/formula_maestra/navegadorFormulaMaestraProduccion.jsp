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
            <style>
                td{
                    padding:0.4em !important;
                }
            </style>
        </head>
        <body>
            <h:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedFormulaMaestra.cargarFormulasMaestrasProduccion}"   />
                    <%--a4j:jsFunction action="#{ManagedFormulaMaestra.tiposProduccion_change}" name="cargarF" reRender="dataFormula" /--%>
                    <h:outputText styleClass="outputTextTitulo"  value="Listado de Formulas Maestras de Producción" style="font-size:1.2em !important" />
                    <br><br>
                        <rich:panel headerClass="headerClassACliente" style="width:70%">
                            <f:facet name="header">
                                <h:outputText value="BUSCADOR"/>
                            </f:facet>
                            <h:panelGrid columns="6">
                                <h:outputText value="Estado" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:selectOneMenu value="#{ManagedFormulaMaestra.formulaMaestraBuscar.estadoRegistro.codEstadoRegistro}" styleClass="inputText">
                                    <f:selectItem itemValue="0" itemLabel="--TODOS--"/>
                                    <f:selectItem itemValue="1" itemLabel="Activo"/>
                                    <f:selectItem itemValue="2" itemLabel="No Activo"/>
                                </h:selectOneMenu>
                                <h:outputText value="Area Producción" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:selectOneMenu value="#{ManagedFormulaMaestra.formulaMaestraBuscar.componentesProd.areasEmpresa.codAreaEmpresa}" styleClass="inputText">
                                    <f:selectItem itemValue="0" itemLabel="--TODOS--"/>
                                    <f:selectItems value="#{ManagedFormulaMaestra.areasEmpresaProduccionSelectList}"/>
                                </h:selectOneMenu>
                            </h:panelGrid>
                            <center>
                                <a4j:commandButton value="BUSCAR" styleClass="btn" action="#{ManagedFormulaMaestra.buscarFormulaMaestraProduccion}"
                                reRender="dataFormula"/>
                            </center>
                        </rich:panel>
                   
                   <rich:dataTable value="#{ManagedFormulaMaestra.formulaMaestrasProduccionList}" var="data" id="dataFormula"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    style="margin-top:1em"
                                    headerClass="headerClassACliente" binding="#{ManagedFormulaMaestra.formulasMaestrasProduccionDataTable}">
                    <f:facet name="header">
                         <rich:columnGroup>
                            
                                <rich:column>
                                    <h:outputText value="Producto" styleClass="outputText2" style="font-weight:bold"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Tamaño Lote" styleClass="outputText2" style="font-weight:bold"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Estado Registro" styleClass="outputText2" style="font-weight:bold"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Nro Version" styleClass="outputText2" style="font-weight:bold"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Fecha Inicio Vigencia" styleClass="outputText2" style="font-weight:bold"/>
                                </rich:column>
                                <%--rich:column>
                                    <h:outputText value="Versiones" styleClass="outputText2" style="font-weight:bold"/>
                                </rich:column--%>
                                <rich:column>
                                    <h:outputText value="Actividades" styleClass="outputText2" style="font-weight:bold"/>
                                </rich:column>

                        </rich:columnGroup>
                        </f:facet>
                        <rich:column>
                            <h:outputText value="#{data.componentesProd.nombreProdSemiterminado}" styleClass="outputText2"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.cantidadLote}" styleClass="outputText2">
                                <f:convertNumber pattern="#####.0" locale="EN"/>
                            </h:outputText>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.estadoRegistro.nombreEstadoRegistro}" styleClass="outputText2"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.nroVersionFormulaActiva}" styleClass="outputText2"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.fechaInicioVigenciaFormulaActiva}" styleClass="outputText2">
                                <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                            </h:outputText>
                        </rich:column>
                        <%--rich:column >
                            <h:commandLink action="#{ManagedFormulaMaestra.verVersionesFormulaMaestra}">
                                <h:graphicImage url="../img/organigrama3.jpg" />
                            </h:commandLink>
                        </rich:column--%>
                        <rich:column>
                            <h:commandLink action="#{ManagedFormulaMaestra.verActividadesFormulaMaestra_action}">
                                <h:graphicImage url="../img/organigrama3.jpg" />
                            </h:commandLink>
                        </rich:column>
                    </rich:dataTable>
                    
                    <br>
                    <rich:panel headerClass="headerClassACliente" rendered="#{ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal eq '1738'|| ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal eq '826' || ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal eq '1033'}">
                        <f:facet name="header">
                            <h:outputText value="Opciones Generales"/>
                        </f:facet>
                    <a4j:commandButton value="Agregar Maquinarias"   styleClass="btn"  action="#{ManagedFormulaMaestra.cargarCambioGeneral}" oncomplete="Richfaces.showModalPanel('panelCambioGeneral')" reRender="contenidoCambioGeneral"/>
                    <a4j:commandButton value="Inactivar/Activar Maquinarias" action="#{ManagedFormulaMaestra.cargarCambioGeneral}"   styleClass="btn"   oncomplete="Richfaces.showModalPanel('panelInactivarGeneral')" reRender="contenidoInactivarGeneral"/>
                    <a4j:commandButton value="Inactivar/Activar actividades"  action="#{ManagedFormulaMaestra.cargarCambioActividadGeneral_action}" styleClass="btn"   oncomplete="Richfaces.showModalPanel('panelCambioActividadGeneral')" reRender="contenidoCambioActividadGeneral"/>
                    <a4j:commandButton styleClass="btn" value="Agregar Actividad General"  onclick="var a=Math.random();window.location='../formula_maestra/agregarActividadesGeneral.jsf?a='+a"/>
                    <a4j:commandButton styleClass="btn" value="Duplicar Actividades"  onclick="var b=Math.random();window.location='../formula_maestra/duplicarActividadesFormulaMaestra.jsf?b='+b"/>
                    <a4j:commandButton styleClass="btn" value="Asignar Horas Hombre/Maquina"  onclick="var b=Math.random();window.location='../formula_maestra/asignarHorasGeneral.jsf?b='+b"/>

                    <h:commandButton value="Horas Promedio Productos"  action="#{ManagedActividadesFormulaMaestra.actualizarTiemposProducto_action}" styleClass="btn"   />
                    <a4j:commandButton value="Copiar Materiales" action="#{ManagedFormulaMaestra.cargarFormulaMaestraCopia}" reRender="contenidoCopiaMaterialReactivo" oncomplete="Richfaces.showModalPanel('panelCopiaMaterialReactivo')" styleClass="btn" />

                    </rich:panel></div>
                
            </h:form>
           
        </body>
    </html>
    
</f:view>

