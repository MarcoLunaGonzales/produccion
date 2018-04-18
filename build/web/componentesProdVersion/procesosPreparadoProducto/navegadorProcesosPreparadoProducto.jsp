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
            <script type="text/javascript">
                function verificarProcesoOm()
                {
                    if(document.getElementById("form1:nombreProceso").innerHTML.length == 0)
                        javascript:Richfaces.showModalPanel('panelSeleccionProcesoOm');
                }
                function retornarNavegadorFm(codigo)
                {
                    var direccion=(codigo>0?"navegadorComponentesProdVersion":"navegadorNuevosComponentesProd");
                    var a=Math.random();
                    window.location.href="../"+direccion+".jsf?cod"+codigo+"="+a;
                }
                function validarAgregarModificarEspecificacionesProcesos()
                {
                    var tabla=document.getElementById("formEditar:dataEspecificacionesMaquinaria").getElementsByTagName("tbody")[0];
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
                }
            </script>
             
        </head>
        <body onload="verificarProcesoOm();" >    
            <center>
                <h:form id="form1"  >
                    <h:outputText value="#{ManagedProcesosPreparadoProducto.cargarProcesosPreparadoProducto}"/>
                    
                    <h:outputText styleClass="outputTextTituloSistema"  value="Procesos de Preparado por Producto" />
                
                    <rich:panel headerClass="headerClassACliente" style="width:60%" id="contenidoCabecera">
                        <f:facet name="header">
                            <h:outputText value="<center>Datos Producto Semiterminado</center>" escape="false"/>
                        </f:facet>
                            <h:panelGrid columns="3">
                                <h:outputText value="Procesos del producto" styleClass="outputTextBold" />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:outputText value="#{ManagedProcesosPreparadoProducto.componentesProdVersionBean.nombreProdSemiterminado}" styleClass="outputText2"/>
                                <h:outputText value="Procesos Orden de Manufactura" styleClass="outputTextBold" />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <a4j:commandLink oncomplete="javascript:Richfaces.showModalPanel('panelSeleccionProcesoOm');">
                                    <h:outputText value="#{ManagedProcesosPreparadoProducto.procesosOrdenManufacturaBean.nombreProcesoOrdenManufactura}" id="nombreProceso" styleClass="outputText2"/>
                                    <h:graphicImage url="../../img/actualizar2.png" alt="Cambiar Proceso"/>
                                </a4j:commandLink>
                                <h:outputText value="Forma Farmaceútica" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:outputText value="#{ManagedProcesosPreparadoProducto.componentesProdVersionBean.forma.nombreForma}" styleClass="outputText2"/>
                             </h:panelGrid>
                    </rich:panel>
                <h:panelGrid id="contenido">
                <rich:dataTable value="#{ManagedProcesosPreparadoProducto.procesosPreparadoProductoList}"
                                    var="data" id="dataProcesosProducto"
                                    style="margin-top:1em"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';"
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo"
                                    binding="#{ManagedProcesosPreparadoProducto.procesosPreparadoDataTable}" >
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
                                <h:outputText value="Consumo<br>de<br>materiales" escape="false"/>
                            </rich:column>
                            <rich:column colspan="3">
                                <h:outputText value="Maquinarias"/>
                            </rich:column>
                            <rich:column rowspan="2">
                                <h:outputText value="Descripción<br> Sub Procesos" escape="false"/>
                            </rich:column>
                            <rich:column rowspan="2">
                                <h:outputText value="Sub Procesos"/>
                            </rich:column>
                            <rich:column breakBefore="true">
                                <h:outputText value="Codigo"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="Nombre"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="Especificación"/>
                            </rich:column>
                        </rich:columnGroup>
                    </f:facet>
                        <rich:subTable value="#{data.procesosPreparadoProductoMaquinariaList}" var="subData" rowKeyVar="key">
                            <rich:column rendered="#{key eq 0}" rowspan="#{data.procesosPreparadoProductoMaquinariaListSize}">
                                <h:outputText value="#{data.nroPaso}" styleClass="outputText2" />
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
                            <rich:column style="text-align:center" rendered="#{key eq 0}" rowspan="#{data.procesosPreparadoProductoMaquinariaListSize}">
                                    <rich:dropDownMenu >
                                        <f:facet name="label">
                                            <h:panelGroup>
                                                <h:outputText value="Acciones"/>
                                                <h:outputText styleClass="icon-menu3"/>
                                            </h:panelGroup>
                                        </f:facet>
                                        <rich:menuItem  submitMode="none" iconClass="icon-pencil2" value="Editar" >
                                            <a4j:support event="onclick" oncomplete="redireccionar('editarProcesosPreparadoProducto.jsf')" >
                                                <f:setPropertyActionListener target="#{ManagedProcesosPreparadoProducto.procesosPreparadoProductoEditar}"
                                                                             value="#{data}"/>
                                            </a4j:support>
                                        </rich:menuItem>
                                        <rich:menuItem  submitMode="none" iconClass="icon-cross" value="Eliminar" >
                                            <a4j:support event="onclick" reRender="dataProcesosProducto"
                                                         oncomplete="mostrarMensajeTransaccion()"
                                                         action="#{ManagedProcesosPreparadoProducto.eliminarProcesosPreparadoProducto_action(data.codProcesoPreparadoProducto)}" >
                                            </a4j:support>
                                        </rich:menuItem>
                                        <rich:menuItem  submitMode="none" iconClass="icon-indent-increase" value="Consumo de Materiales" >
                                            <a4j:support event="onclick" reRender="contenidoMostrarConsumoMaterial"
                                                         oncomplete="Richfaces.showModalPanel('panelMostrarConsumoMaterial');"
                                                         action="#{ManagedProcesosPreparadoProducto.mostrarConsumoMaterialProcesoPreparadoProducto_action}">
                                                <f:setPropertyActionListener target="#{ManagedProcesosPreparadoProducto.procesosPreparadoProductoMaterial}"
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
                                <a4j:commandLink rendered="#{subData.codProcesoPreparadProductoMaquinaria>0}" action="#{ManagedProcesosPreparadoProducto.mostrarProcesosPreparadoProductoEspecificacionesMaquinaria_action}"
                                oncomplete="Richfaces.showModalPanel('panelMostrarEspecificacionesEquipo');" reRender="contenidoMostrarEspecificacionesEquip">
                                    <f:setPropertyActionListener value="#{subData}" target="#{ManagedProcesosPreparadoProducto.procesosPreparadoProductoMaquinariaBean}"/>
                                    <f:setPropertyActionListener value="#{data}" target="#{ManagedProcesosPreparadoProducto.procesosPreparadoProductoBean}"/>
                                    <h:graphicImage url="../../img/maquinaria.jpg" title="Especificaciones Maquinaria"/>
                                </a4j:commandLink>
                            </rich:column>
                            <rich:column rendered="#{key eq 0}" rowspan="#{data.procesosPreparadoProductoMaquinariaListSize}">
                                <rich:dataTable value="#{data.subProcesosPreparadoProductoList}" var="subTabla"
                                                style="width:100%" headerClass="subTablaHeader" rendered="#{data.subProcesosPreparadoProductoListSize>0}">
                                    <f:facet name="header">
                                        <rich:columnGroup >
                                            <rich:column rowspan="2">
                                                <h:outputText value="Nro.<br> Sub Proceso" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="2">
                                                <h:outputText value="Actividad<br>Preparado" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="2">
                                                <h:outputText value="Descripción"/>
                                            </rich:column>
                                            <rich:column colspan="2">
                                                <h:outputText value="Maquinaria"/>
                                            </rich:column>
                                            <rich:column breakBefore="true">
                                                <h:outputText value="Codigo"/>
                                            </rich:column>
                                            <rich:column >
                                                <h:outputText value="Nombre"/>
                                            </rich:column>
                                        </rich:columnGroup>
                                    </f:facet>
                                        <rich:subTable value="#{subTabla.procesosPreparadoProductoMaquinariaList}" var="subMaquina" rowKeyVar="subKey">
                                            <rich:column  rendered="#{subKey eq 0}" rowspan="#{subTabla.procesosPreparadoProductoMaquinariaListSize}">
                                                <h:outputText value="#{data.nroPaso}.#{subTabla.nroPaso}" styleClass="outputText2" />
                                            </rich:column >
                                            <rich:column  rendered="#{subKey eq 0}" rowspan="#{subTabla.procesosPreparadoProductoMaquinariaListSize}">
                                                <h:outputText value="#{subTabla.actividadesPreparado.nombreActividadPreparado}" styleClass="outputText2" />
                                            </rich:column >
                                            <rich:column  rendered="#{subKey eq 0}" rowspan="#{subTabla.procesosPreparadoProductoMaquinariaListSize}">
                                                <h:outputText value="#{subTabla.descripcion}" styleClass="outputText2" />
                                            </rich:column >
                                            <rich:column>
                                                <h:outputText value="#{subMaquina.maquinaria.codigo}"/>
                                            </rich:column>
                                            <rich:column>
                                                <h:outputText value="#{subMaquina.maquinaria.nombreMaquina}"/>
                                            </rich:column>
                                        </rich:subTable>
                                </rich:dataTable>
                            </rich:column>
                            
                            <rich:column rendered="#{key eq 0}" rowspan="#{data.procesosPreparadoProductoMaquinariaListSize}">
                                <a4j:commandLink action="#{ManagedProcesosPreparadoProducto.seleccionarProcesoPreparadoBean}"
                                                 oncomplete="window.location.href='navegadorSubProcesosPreparadoProducto.jsf?data='+(new Date()).getTime().toString();" >
                                        <h:graphicImage url="../../img/subProcesos.jpg" title="Mostrar SubProcesos"/>
                                </a4j:commandLink>
                            </rich:column>
                        </rich:subTable>
                   </rich:dataTable>
            </h:panelGrid>

                    <br>
                        <a4j:commandButton value="Agregar" styleClass="btn" onclick="window.location.href='agregarProcesosPreparadoProducto.jsf?data='+(new Date()).getTime().toString();" />
                        
                        <a4j:commandButton oncomplete="retornarNavegadorFm(#{ManagedProcesosPreparadoProducto.componentesProdVersionBean.codCompprod})" styleClass="btn"  value="Volver"/>
                    <%--a4j:commandButton value="Recalcular Cantidades" styleClass="btn" action="#{ManagedProcesosProducto.mostrarCantidadesMaterialesGlobalesRecalcular}" oncomplete="Richfaces.showModalPanel('panelRecalcularCantidadesFormaFar')"
                     reRender="formContenidoRecalcular"/--%>
                    </div>            
                </h:form>
                
            <rich:modalPanel id="panelSeleccionProcesoOm" autosized="true"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" >
                        <f:facet name="header">
                            <h:outputText value="Seleccionar Proceso de Preparado"/>
                        </f:facet>
                        <a4j:form id="formContenidoRecalcular">
                        <h:panelGroup id="contenidoSeleccionProcesoOm">
                            <center>
                                <rich:dataTable value="#{ManagedProcesosPreparadoProducto.procesosOrdenManufacturaList}"
                                    var="data" id="dataProcesosProducto"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';"
                                    headerClass="headerClassACliente"
                                    binding="#{ManagedProcesosPreparadoProducto.procesosOrdenManufacturaDataTable}"
                                    columnClasses="tituloCampo">
                                    <f:facet name="header">
                                        <rich:columnGroup>
                                            <rich:column>
                                                <h:outputText value="Proceso Orden  Manufactura"/>
                                            </rich:column>
                                        </rich:columnGroup>
                                    </f:facet>
                                    <rich:column>
                                        <a4j:commandLink action="#{ManagedProcesosPreparadoProducto.seleccionarProcesoOrdenManufactura}"
                                                         oncomplete="javascript:Richfaces.hideModalPanel('panelSeleccionProcesoOm')" reRender="contenido,contenidoCabecera">
                                            <h:outputText value="#{data.nombreProcesoOrdenManufactura}"/>
                                        </a4j:commandLink>
                                    </rich:column>
                                </rich:dataTable>
                            </center>
                                <br>
                                <div align="center">
                                    <a4j:commandButton  value="Cancelar"oncomplete="javascript:Richfaces.hideModalPanel('panelSeleccionProcesoOm')" styleClass="btn" rendered="#{ManagedProcesosPreparadoProducto.procesosOrdenManufacturaBean.codProcesoOrdenManufactura>0}"/>
                                    <a4j:commandButton oncomplete="retornarNavegadorFm(#{ManagedProcesosPreparadoProducto.componentesProdVersionBean.codCompprod})" styleClass="btn"  value="Volver" rendered="#{ManagedProcesosPreparadoProducto.procesosOrdenManufacturaBean.codProcesoOrdenManufactura eq 0}"/>
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>
            
                 <rich:modalPanel id="panelMostrarEspecificacionesEquipo" minHeight="300"  minWidth="850"
                                     height="410" width="850"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" >
                        <f:facet name="header">
                            <h:outputText value="<center>Especificaciones de equipo</center>" escape="false"/>
                        </f:facet>
                        <a4j:form id="formEditar">
                        <h:panelGroup id="contenidoMostrarEspecificacionesEquip">
                            <rich:panel headerClass="headerClassACliente">
                                <f:facet name="header">
                                    <h:outputText value="<center>Datos de la maquina<center>" escape="false"/>
                                </f:facet>
                                <center>
                                    <h:panelGrid columns="6">
                                        <h:outputText value="Nro. Paso" styleClass="outputTextBold"/>
                                        <h:outputText value="::" styleClass="outputTextBold"/>
                                        <h:outputText value="#{ManagedProcesosPreparadoProducto.procesosPreparadoProductoMaquinariaBean.procesosPreparadoProducto.nroPaso}" styleClass="outputText2"/>
                                        <h:outputText value="Nombre Actividad Proceso" styleClass="outputTextBold"/>
                                        <h:outputText value="::" styleClass="outputTextBold"/>
                                        <h:outputText value="#{ManagedProcesosPreparadoProducto.procesosPreparadoProductoMaquinariaBean.procesosPreparadoProducto.actividadesPreparado.nombreActividadPreparado}" styleClass="outputText2"/>
                                        <h:outputText value="Maquina" styleClass="outputTextBold"/>
                                        <h:outputText value="::" styleClass="outputTextBold"/>
                                        <h:outputText value="#{ManagedProcesosPreparadoProducto.procesosPreparadoProductoMaquinariaBean.maquinaria.nombreMaquina}" styleClass="outputText2"/>
                                        <h:outputText value="Codigo" styleClass="outputTextBold"/>
                                        <h:outputText value="::" styleClass="outputTextBold"/>
                                        <h:outputText value="#{ManagedProcesosPreparadoProducto.procesosPreparadoProductoMaquinariaBean.maquinaria.codigo}" styleClass="outputText2"/>
                                    </h:panelGrid>
                                </center>
                            </rich:panel>
                                <center>
                                    <table>
                                        <tr>
                                            <td>
                                                <div style="height:220px;width:780px;overflow: auto">

                                                <rich:dataTable value="#{ManagedProcesosPreparadoProducto.procesosPreparadoProductoMaquinariaBean.procesosPreparadoProductoEspecificacionesMaquinariaList}"
                                                    var="data" id="dataEspecificacionesMaquinaria"
                                                    headerClass="headerClassACliente"
                                                    columnClasses="tituloCampo">
                                                    <f:facet name="header">
                                                        <rich:columnGroup>
                                                            <rich:column>
                                                                <h:outputText value=" "/>
                                                            </rich:column>
                                                            <rich:column>
                                                                <h:outputText value="Nombre Especificación</br><input class='inputText' onkeyup='buscarCeldaAgregar(this,1)' type='text'" escape="false"/>
                                                            </rich:column>
                                                            <rich:column>
                                                                <h:outputText value="Tipo Descripción "/>
                                                            </rich:column>
                                                            <rich:column>
                                                                <h:outputText value="Descripción "/>
                                                            </rich:column>
                                                            <rich:column>
                                                                <h:outputText value="Unidad Medida"/>
                                                            </rich:column>
                                                            <rich:column>
                                                                <h:outputText value="Resultado<br>Esperado Lote" escape="false"/>
                                                            </rich:column>
                                                            <rich:column>
                                                                <h:outputText value="Porciento<br>Tolerancia" escape="false"/>
                                                            </rich:column>
                                                        </rich:columnGroup>
                                                    </f:facet>
                                                        <rich:column>
                                                            <h:selectBooleanCheckbox value="#{data.checked}"/>
                                                        </rich:column>
                                                        <rich:column>
                                                            <h:outputText value="#{data.especificacionesProcesos.nombreEspecificacionProceso}" styleClass="outputText2"/>
                                                        </rich:column>
                                                        <rich:column >
                                                            <h:selectOneMenu value="#{data.tiposDescripcion.codTipoDescripcion}" styleClass="inputText">
                                                                <f:selectItems value="#{ManagedProcesosPreparadoProducto.tiposDescripcionSelectList}"/>
                                                                <a4j:support event="onchange" reRender="dataEspecificacionesMaquinaria"/>
                                                            </h:selectOneMenu>
                                                        </rich:column>
                                                        <rich:column >
                                                            <h:inputText value="#{data.valorExacto}" rendered="#{data.tiposDescripcion.codTipoDescripcion>2}" styleClass="inputText" onblur="valorPorDefecto(this)"/>
                                                            <h:inputText value="#{data.valorTexto}" rendered="#{data.tiposDescripcion.codTipoDescripcion eq 1}" styleClass="inputText"/>
                                                            <h:inputText value="#{data.valorMinimo}" style="width:6em" rendered="#{data.tiposDescripcion.codTipoDescripcion eq 2}" styleClass="inputText" onblur="valorPorDefecto(this)"/>
                                                            <h:outputText value="-" rendered="#{data.tiposDescripcion.codTipoDescripcion eq 2}" styleClass="outputText2"/>
                                                            <h:inputText value="#{data.valorMaximo}" style="width:6em" rendered="#{data.tiposDescripcion.codTipoDescripcion eq 2}" styleClass="inputText" onblur="valorPorDefecto(this)"/>
                                                        </rich:column>
                                                        <rich:column>
                                                            <h:selectOneMenu value="#{data.unidadesMedida.codUnidadMedida}" styleClass="inputText" style="width:17em">
                                                                <f:selectItem itemValue="0" itemLabel="--NINGUNO--"/>
                                                                <f:selectItems value="#{ManagedProcesosPreparadoProducto.unidadesMedidaSelectList}"/>
                                                            </h:selectOneMenu>
                                                        </rich:column>
                                                        <rich:column>
                                                            <h:selectBooleanCheckbox value="#{data.resultadoEsperadoLote}"/>
                                                        </rich:column>
                                                        <rich:column>
                                                            <h:inputText onblur="valorPorDefecto(this)" value="#{data.porcientoTolerancia}" size="4" styleClass="inputText"/>
                                                        </rich:column>
                                                    </rich:dataTable>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </center>

                                <div align="center" style="margin-top:1em">
                                    <a4j:commandButton styleClass="btn" value="Guardar"  action="#{ManagedProcesosPreparadoProducto.guardarProcesosPreparadoProductoEspecificacionesMaquinaria_action}"
                                                       onclick="if(!validarAgregarModificarEspecificacionesProcesos()){return false;}"
                                                       oncomplete="mostrarMensajeTransaccionEvento(function(){Richfaces.hideModalPanel('panelMostrarEspecificacionesEquipo');})"/>
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelMostrarEspecificacionesEquipo')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>
            <a4j:include viewId="navegadorConsumoMaterial.jsp" id="consumoMaterial"/>
            <a4j:include viewId="/message.jsp"/>
            <a4j:include viewId="/panelProgreso.jsp"/>

            </center>
        </body>
    </html>
    
</f:view>

