<%@taglib prefix="h" uri="http://java.sun.com/jsf/html" %>
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core" %>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j" %>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>

    <html>
        <head>
            <meta http-equiv="Expires" content="0">
            <meta http-equiv="Last-Modified" content="0">
            <meta http-equiv="Cache-Control" content="no-cache, mustrevalidate">
            <meta http-equiv="Pragma" content="no-cache">
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <script type="text/javascript" src="../../js/general.js" ></script>
            <script type="text/javascript">
                function retornarNavegador(codVersionCp)
                {
                    window.location.href=(codVersionCp>0?'../navegadorComponentesProdVersion.jsf':'../navegadorNuevosComponentesProd.jsf')+"?data="+(new Date()).getTime().toString();
                }
                function onChangeTipoDescripcion(select,idFila)
                {
                    document.getElementById("form1:dataEspecificaciones:"+idFila.toString()+":valorExacto").style.display='none';
                    document.getElementById("form1:dataEspecificaciones:"+idFila.toString()+":valorTexto").style.display='none';
                    document.getElementById("form1:dataEspecificaciones:"+idFila.toString()+":valorMinimo").style.display='none';
                    document.getElementById("form1:dataEspecificaciones:"+idFila.toString()+":valorMinimoR").style.display='none';
                    document.getElementById("form1:dataEspecificaciones:"+idFila.toString()+":valorMaximo").style.display='none';
                    switch(parseInt(select.value))
                    {
                        case 1:
                        {
                            document.getElementById("form1:dataEspecificaciones:"+idFila.toString()+":valorTexto").style.display='';
                            break;
                        }
                        case 2:
                        {
                            document.getElementById("form1:dataEspecificaciones:"+idFila.toString()+":valorMinimo").style.display='';
                            document.getElementById("form1:dataEspecificaciones:"+idFila.toString()+":valorMinimoR").style.display='';
                            document.getElementById("form1:dataEspecificaciones:"+idFila.toString()+":valorMaximo").style.display='';
                            break;
                        }
                        default :
                        {
                            document.getElementById("form1:dataEspecificaciones:"+idFila.toString()+":valorExacto").style.display='';
                        }
                    }
                }
                function validarAgregarModificarEspecificacionesProcesos()
                {
                    if(!alMenosUno("form1:dataEspecificaciones"))
                    {
                        return false;
                    }
                    var tabla=document.getElementById("form1:dataEspecificaciones").getElementsByTagName("tbody")[0];
                    var cantidadRegistrosMenoresIgualesCero=0;
                    for(var i=0;i<tabla.rows.length;i++)
                    {
                        if(tabla.rows[i].cells[0].getElementsByTagName("input")[0].checked&&(!tabla.rows[i].cells[tabla.rows[i].cells.length-2].getElementsByTagName("input")[0].checked))
                        {
                            switch(parseInt(tabla.rows[i].cells[2].getElementsByTagName("select")[0].value))
                            {
                                case 1:
                                {
                                    if(!validarRegistroNoVacio(document.getElementById("form1:dataEspecificaciones:"+i.toString()+":valorTexto")))
                                    {
                                        return false;
                                    }
                                    break;
                                }
                                case 2:
                                {
                                    if(!validarMayorACero(document.getElementById("form1:dataEspecificaciones:"+i.toString()+":valorMinimo"))||
                                       !validarMayorACero(document.getElementById("form1:dataEspecificaciones:"+i.toString()+":valorMaximo")))
                                    {
                                        cantidadRegistrosMenoresIgualesCero++;
                                    }
                                    break;
                                }
                                default:
                                {
                                    if(!validarMayorACero(document.getElementById("form1:dataEspecificaciones:"+i.toString()+":valorExacto")))
                                    {
                                        cantidadRegistrosMenoresIgualesCero++;
                                    }
                                    break;
                                }
                            }
                        }
                    }
                    if(cantidadRegistrosMenoresIgualesCero>0)
                        return confirm("Existen registros con cantidades menores o iguales a cero, esta seguro de registrar?");
                    return true;
                }
            </script>
        </head>
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedComponentesProdVersion.cargarEditarEspecificacionesMaquinariaProcesoProducto}"/>
                    <h:outputText styleClass="outputTextTituloSistema"   value="Agregar Especificaciones por proceso y Maquinaria" />
                    <br/>
                        <rich:panel headerClass="headerClassACliente" style="width:50%">
                            <f:facet name="header">
                                <h:outputText value="Datos del Producto"/>

                            </f:facet>
                            <h:panelGrid columns="3" headerClass="headerClassACliente">
                                <h:outputText value="Producto" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.nombreProdSemiterminado} " styleClass="outputText2"/>
                                <h:outputText value="Proceso Orden Manufactura" styleClass="outputTextBold"/>
                                <h:outputText value=":" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedComponentesProdVersion.componentesProdProcesoOrdenManufacturaBean.formasFarmaceuticasProcesoOrdenManufactura.procesosOrdenManufactura.nombreProcesoOrdenManufactura}" styleClass="outputText2"/>
                                <h:outputText value="Forma farmaceútica" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.forma.nombreForma} " styleClass="outputText2"/>
                                <h:outputText value="Maquinaria" styleClass="outputTextBold"  />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionMaquinariaProcesoEditar.maquinaria.nombreMaquina}"   styleClass="outputText2"/>
                                <h:outputText value="Código Maquinaria" styleClass="outputTextBold"  />
                                <h:outputText value="::" styleClass="outputTextBold" />
                                <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionMaquinariaProcesoEditar.maquinaria.codigo}"   styleClass="outputText2"/>
                            </h:panelGrid>
                        </rich:panel>
                    
                    <rich:dataTable value="#{ManagedComponentesProdVersion.componentesProdVersionMaquinariaProcesoEditar.especificacionesProcesosProductoMaquinariaList}"
                                            var="data" id="dataEspecificaciones" rowKeyVar="idRow"
                                            headerClass="headerClassACliente"  style="margin-top:1em !important">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column>
                                    <h:outputText value=""/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText escape="false" value="Nombre Especificación<br><input type='text' onkeyup='buscarCeldaAgregar(this,1)' class='inputText'>"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Tipo Descripción"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Descripción"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Unidad Medida"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Tolerancia<br>(%)" escape="false"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Resultado<br>Esperado<br>Lote" escape="false"/>
                                </rich:column>
                                <rich:column rendered="#{ManagedComponentesProdVersion.componentesProdProcesoOrdenManufacturaBean.formasFarmaceuticasProcesoOrdenManufactura.aplicaTipoEspecificacionProceso}">
                                    <h:outputText value="Tipo<br>Especificación" escape="false"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                            <rich:columnGroup style="background-color:#{data.checked?'#90EE90':'#ffffff'}">
                                <rich:column>
                                    <h:selectBooleanCheckbox value="#{data.checked}" onclick="seleccionarRegistro(this)"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="#{data.especificacionesProcesos.nombreEspecificacionProceso}"/>
                                </rich:column>
                                <rich:column >
                                    <h:selectOneMenu value="#{data.tiposDescripcion.codTipoDescripcion}" styleClass="inputText" onchange="onChangeTipoDescripcion(this,#{idRow})">
                                        <f:selectItems value="#{ManagedComponentesProdVersion.tiposDescripcionSelectList}"/>
                                    </h:selectOneMenu>
                                </rich:column>
                                <rich:column >
                                    <h:inputText id="valorExacto" onblur="valorPorDefecto(this)" value="#{data.valorExacto}" style="display:#{data.tiposDescripcion.codTipoDescripcion>2?'':'none'}" styleClass="inputText"/>
                                    <h:inputText id="valorTexto" value="#{data.valorTexto}" style="display:#{data.tiposDescripcion.codTipoDescripcion eq 1?'':'none'}"  styleClass="inputText"/>
                                    <h:inputText id="valorMinimo" onblur="valorPorDefecto(this)" value="#{data.valorMinimo}" style="width:6em;display:#{data.tiposDescripcion.codTipoDescripcion eq 2?'':'none'}" styleClass="inputText"/>
                                    <h:outputText id="valorMinimoR" value="-" style="display:#{data.tiposDescripcion.codTipoDescripcion eq 2?'':'none'}" styleClass="outputText2"/>
                                    <h:inputText id="valorMaximo" onblur="valorPorDefecto(this)" value="#{data.valorMaximo}" style="width:6em;display:#{data.tiposDescripcion.codTipoDescripcion eq 2?'':'none'}" styleClass="inputText"/>
                                </rich:column>
                                <rich:column>
                                    <h:selectOneMenu value="#{data.unidadesMedida.codUnidadMedida}" styleClass="inputText">
                                        <f:selectItem itemLabel="--Ninguno--" itemValue="0"/>
                                        <f:selectItems value="#{ManagedComponentesProdVersion.unidadesMedidaGeneralSelectList}"/>
                                    </h:selectOneMenu>
                                </rich:column>
                                <rich:column>
                                    <h:inputText value="#{data.porcientoTolerancia}" styleClass="inputText"/>
                                </rich:column>
                                <rich:column>
                                    <h:selectBooleanCheckbox value="#{data.resultadoEsperadoLote}"/>
                                </rich:column>
                                <rich:column rendered="#{ManagedComponentesProdVersion.componentesProdProcesoOrdenManufacturaBean.formasFarmaceuticasProcesoOrdenManufactura.aplicaTipoEspecificacionProceso}">
                                    <h:selectOneMenu styleClass="inputText" value="#{data.tiposEspecificacionesProcesosProductoMaquinaria.codTipoEspecificacionProcesoProductoMaquinaria}">
                                        <f:selectItem itemLabel="N.A." itemValue='0'/>
                                        <f:selectItems value="#{ManagedComponentesProdVersion.tiposEspecificacionesProcesoProductoMaquinariaSelectList}"/>
                                    </h:selectOneMenu>
                                </rich:column>
                            </rich:columnGroup>
                        </rich:dataTable>
                        <div id="bottonesAcccion" class="barraBotones">
                                <a4j:commandButton value="Guardar" styleClass="btn" action="#{ManagedComponentesProdVersion.guardarEditarComponentesProdVersionMaquinariaProceso_action}"
                                                   onclick="if(!validarAgregarModificarEspecificacionesProcesos()){return false;}"
                                                   oncomplete="mostrarMensajeTransaccionEvento(function(){redireccionar('navegadorMaquinariasPorProceso.jsf')})"/>
                                <a4j:commandButton value="Cancelar"  styleClass="btn" oncomplete="window.location.href='navegadorMaquinariasPorProceso.jsf?save='+(new Date()).getTime().toString()"/>
                         </div>   
                         
                </div>

               
              
            </a4j:form>

             
            <a4j:include viewId="/panelProgreso.jsp"/>
            <a4j:include viewId="/message.jsp"/>
    </html>

</f:view>

