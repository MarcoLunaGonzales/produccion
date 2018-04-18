<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <script type="text/javascript" src="../../js/general.js"></script>
            <style>
                .noValido{
                    background-color:#FFA07A;
                }
            </style>
            <script type="text/javascript">
                function validarAgregarModificarEspecificacionesProcesos()
                {
                    try
                    {
                        var tabla=document.getElementById("panelEspMaquinaria:formEditar:dataEspecificacionesMaquinaria").getElementsByTagName("tbody")[0];
                        for(var i=0;i<tabla.rows.length;i++)
                        {
                            if(tabla.rows[i].cells[0].getElementsByTagName("input")[0].checked&&(!tabla.rows[i].cells[5].getElementsByTagName("input")[0].checked))
                            {
                                switch(parseInt(tabla.rows[i].cells[2].getElementsByTagName("select")[0].value))
                                {
                                    case 1:
                                    {
                                        if(!validarRegistroNoVacio(tabla.rows[i].cells[3].getElementsByTagName("input")[0]))
                                        {
                                            return false;
                                        }
                                        break;
                                    }
                                    case 2:
                                    {
                                        if(!validarMayorACero(tabla.rows[i].cells[3].getElementsByTagName("input")[0])||
                                           !validarMayorACero(tabla.rows[i].cells[3].getElementsByTagName("input")[1]))
                                        {
                                            return false;
                                        }
                                    }
                                    default:
                                    {
                                        if(!validarMayorACero(tabla.rows[i].cells[3].getElementsByTagName("input")[0]))
                                        {
                                            return false;
                                        }
                                        break;
                                    }
                                }
                            }
                            if(tabla.rows[i].cells[0].getElementsByTagName("input")[0].checked)
                            {
                                if(!validarMayorIgualACero(tabla.rows[i].cells[6].getElementsByTagName("input")[0]))
                                {
                                    return false;
                                }
                            }
                        }
                        return true;
                    }catch(e)
                    {
                        alert(e);
                        return false;
                    }
                }
            </script>
        </head>
        <body >    
            <center>
                <h:form id="form1"  >
                    <h:outputText value="#{ManagedProductosDesarrolloVersion.cargarSubProcesosPreparadoProducto}"/>
                    <h:outputText styleClass="outputTextTituloSistema"  value="Sub Procesos de Preparado por Producto" />
                    <rich:panel headerClass="headerClassACliente" style="width:50%">
                        <f:facet name="header">
                            <h:outputText value="Datos del Proceso Padre" />
                        </f:facet>
                        <h:panelGrid columns="3">
                            <h:outputText value="N° Paso" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedProductosDesarrolloVersion.procesosPreparadoProductoBeanSubProceso.nroPaso}" styleClass="outputText2"/>
                            <h:outputText value="Actividad" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedProductosDesarrolloVersion.procesosPreparadoProductoBeanSubProceso.actividadesPreparado.nombreActividadPreparado}" styleClass="outputText2"/>
                            <h:outputText value="Descripción" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedProductosDesarrolloVersion.procesosPreparadoProductoBeanSubProceso.actividadesPreparado.nombreActividadPreparado}" styleClass="outputText2"/>
                        </h:panelGrid>
                    </rich:panel>
                
                    <rich:dataTable value="#{ManagedProductosDesarrolloVersion.subProcesosPreparadoProductoList}"
                                    var="data" id="dataProcesosProducto" style="margin-top:1em"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';"
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo">
                    <f:facet name="header">
                        <rich:columnGroup>
                            <rich:column rowspan="2">
                                <h:outputText value="Nro paso"/>
                            </rich:column>
                            <rich:column rowspan="2">
                                <h:outputText value="Actividad Preparado"/>
                            </rich:column>
                            <rich:column rowspan="2">
                                <h:outputText value="Tiempo Proceso"/>
                            </rich:column>
                            <rich:column rowspan="2">
                                <h:outputText value="Descripción"/>
                            </rich:column>
                            <rich:column rowspan="2">
                                <h:outputText value="Sustancia<br/>Resultante" escape="false"/>
                            </rich:column>
                            <rich:column rowspan="2">
                                <h:outputText value="Proceso<br/>Destino" escape="false"/>
                            </rich:column>
                            <rich:column rowspan="2">
                                <h:outputText value="Consumo de materiales"/>
                            </rich:column>
                            <rich:column colspan="3">
                                <h:outputText value="Maquinarias"/>
                            </rich:column>
                            <rich:column breakBefore="true">
                                <h:outputText value="Nombre"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="Codigo"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="Especificación"/>
                            </rich:column>
                        </rich:columnGroup>
                    </f:facet>
                        <rich:subTable value="#{data.procesosPreparadoProductoMaquinariaList}" var="subData" rowKeyVar="key">
                            <rich:column rendered="#{key eq 0}" rowspan="#{data.procesosPreparadoProductoMaquinariaListSize}">
                                <h:outputText value="#{ManagedProductosDesarrolloVersion.procesosPreparadoProductoBeanSubProceso.nroPaso}.#{data.nroPaso}" styleClass="outputText2" />
                            </rich:column >
                            <rich:column rendered="#{key eq 0}" rowspan="#{data.procesosPreparadoProductoMaquinariaListSize}">
                                <h:outputText value="#{data.actividadesPreparado.nombreActividadPreparado}" styleClass="outputText2" />
                            </rich:column >
                            <rich:column rendered="#{key eq 0}" rowspan="#{data.procesosPreparadoProductoMaquinariaListSize}">
                                <h:outputText value="#{data.tiempoProceso} min " styleClass="outputText2" rendered="#{data.tiempoProceso>0}"/>
                            </rich:column >
                            <rich:column rendered="#{key eq 0}" rowspan="#{data.procesosPreparadoProductoMaquinariaListSize}">
                                <h:outputText value="#{data.descripcion}" styleClass="outputText2" />
                            </rich:column >
                            <rich:column rendered="#{key eq 0}" rowspan="#{data.procesosPreparadoProductoMaquinariaListSize}">
                                <h:outputText value="#{data.sustanciaResultante}" styleClass="outputText2" />
                            </rich:column >
                            <rich:column rendered="#{key eq 0}" rowspan="#{data.procesosPreparadoProductoMaquinariaListSize}">
                                <h:outputText value="#{data.procesosPreparadoProductoDestino.nroPaso} - #{data.procesosPreparadoProductoDestino.actividadesPreparado.nombreActividadPreparado}" styleClass="outputText2"
                                              rendered="#{data.procesosPreparadoProductoDestino != null}"/>
                            </rich:column >
                            <rich:column style="text-align:center" rendered="#{key eq 0}" rowspan="#{data.procesosPreparadoProductoMaquinariaListSize}">
                                <rich:dropDownMenu >
                                    <f:facet name="label">
                                        <h:panelGroup>
                                            <h:outputText value="Acciones"/>
                                            <h:outputText styleClass="icon-menu3"/>
                                        </h:panelGroup>
                                    </f:facet>
                                    <rich:menuItem  submitMode="none" iconClass="icon-pencil2" value="Editar" >
                                        <a4j:support event="onclick" oncomplete="redireccionar('editarSubProcesosPreparadoProducto.jsf')" >
                                            <f:setPropertyActionListener target="#{ManagedProductosDesarrolloVersion.procesosPreparadoProducto}" value="#{data}"/>
                                        </a4j:support>
                                    </rich:menuItem>
                                    <rich:menuItem  submitMode="none" iconClass="icon-cross" value="Eliminar" >
                                        <a4j:support event="onclick" reRender="dataProcesosProducto"
                                                     oncomplete="mostrarMensajeTransaccion()"
                                                     action="#{ManagedProductosDesarrolloVersion.eliminarSubProcesosPreparadoProductoAction(data.codProcesoPreparadoProducto)}" >
                                        </a4j:support>
                                    </rich:menuItem>
                                    <rich:menuItem  submitMode="none" iconClass="icon-indent-increase" value="Consumo de Materiales" >
                                        <a4j:support event="onclick" reRender="contenidoMostrarConsumoMaterial"
                                                        oncomplete="Richfaces.showModalPanel('panelMostrarConsumoMaterial');"
                                                        action="#{ManagedProductosDesarrolloVersion.seleccionarProcesoPreparadoConsumoAction}">
                                               <f:setPropertyActionListener target="#{ManagedProductosDesarrolloVersion.procesosPreparadoProducto}"
                                                       value="#{data}"/>
                                        </a4j:support>
                                    </rich:menuItem>

                                </rich:dropDownMenu>
                                
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{subData.maquinaria.nombreMaquina}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{subData.maquinaria.codigo}"/>
                            </rich:column>
                            <rich:column>
                                <a4j:commandLink rendered="#{subData.codProcesoPreparadProductoMaquinaria>0}" action="#{ManagedProductosDesarrolloVersion.mostrarProcesosPreparadoProductoEspecificacionesMaquinariaAction()}"
                                oncomplete="Richfaces.showModalPanel('panelMostrarEspecificacionesEquipo');" reRender="contenidoMostrarEspecificacionesEquip">
                                    <f:setPropertyActionListener value="#{subData}" target="#{ManagedProductosDesarrolloVersion.procesosPreparadoProductoMaquinaria}"/>
                                    <f:setPropertyActionListener value="#{data}" target="#{ManagedProductosDesarrolloVersion.procesosPreparadoProducto}"/>
                                    <h:graphicImage url="../../img/maquinaria.jpg" title="Especificaciones Maquinaria"/>
                                </a4j:commandLink>
                            </rich:column>
                        </rich:subTable>
                   </rich:dataTable>
                    <br>
                        <a4j:commandButton value="Agregar" styleClass="btn" onclick="window.location.href='agregarSubProcesosPreparadoProducto.jsf?data='+(new Date()).getTime().toString();" />
                        <a4j:commandButton value="Volver" styleClass="btn" onclick="window.location.href='navegadorProcesosPreparadoProducto.jsf?data='+(new Date()).getTime().toString();" />
                    </div>            
                </h:form>
                 
            <a4j:include viewId="navegadorConsumoMaterial.jsp" id="consumoMaterial"/>
            <a4j:include viewId="panelEspecificacionesMaquinaria.jsp" id="panelEspMaquinaria"/>
            <a4j:include viewId="/message.jsp"/>
            <a4j:include viewId="/panelProgreso.jsp"/>

        </body>
    </html>
    
</f:view>

