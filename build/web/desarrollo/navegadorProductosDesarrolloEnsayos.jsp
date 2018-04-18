<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <link rel="STYLESHEET" type="text/css" href="../css/icons.css" />
            <script type="text/javascript" src="../js/general.js"></script>
            <style>
                .enProceso{
                    background-color:#c9fdc9;
                }
                .enviadoAprobacion{
                    background-color:#fac5af;
                }
            </style>
            <script type="text/javascript">
                function verRegistroSanitario(codVersion)
                {
                    var a=new Date();
                    document.getElementById('frameSubir').src="subirArchivoPdf.jsf?codVersion="+codVersion+"&a="+Math.random()+"&date="+(a.getTime.toString());
                }
                function ocultaRegistro()
                {
                    Richfaces.hideModalPanel('modalPanelSubirArchivo');
                }
                function refrescar()
                {
                    ok();
                }
            </script>
        </head>
        <body>
            <h:form id="form1"  >                
                <div align="center">                    
                    <a4j:jsFunction name="ok" id="ok" reRender="form1" oncomplete="Richfaces.hideModalPanel('modalPanelSubirArchivo')"/>
                    <h:outputText value="#{ManagedProductosDesarrolloVersion.cargarComponentesProdDesarrolloEnsayoList}"   />
                    <h:outputText value="Versiones del Producto" styleClass="outputTextTituloSistema"/>
                    <rich:dataTable value="#{ManagedProductosDesarrolloVersion.componentesProdDesarrolloEnsayoList}"
                                    var="data" id="dataComponentesProd"
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo"
                                    style="margin-top:1em;">
                            <f:facet name="header">
                                <rich:columnGroup>
                                        <rich:column rowspan="2">
                                            <h:outputText value="Nombre<br>Producto" escape="false"/>
                                        </rich:column>
                                        <rich:column rowspan="2">
                                            <h:outputText value="Tamaño<br>Lote<br>Producción" escape="false"/>
                                        </rich:column>
                                        <rich:column rowspan="2">
                                            <h:outputText value="Producto<br>Semi-elaborado" escape="false"/>
                                        </rich:column>
                                        <rich:column rowspan="2">
                                            <h:outputText value="Area<br>Fabricación" escape="false"/>
                                        </rich:column>
                                        <rich:column rowspan="2">
                                            <h:outputText value="Nombre<br>Comercial" escape="false"/>
                                        </rich:column>
                                        <rich:column colspan="3" >
                                            <h:outputText value="Datos Registro Sanitario" escape="false"/>
                                        </rich:column>
                                        <rich:column rowspan="2">
                                            <h:outputText value="Forma<br>Farmaceútica" escape="false"/>
                                        </rich:column>
                                        <rich:column rowspan="2">
                                            <h:outputText value="Volumen<br>Envase<br>Primario" escape="false"/>
                                        </rich:column>
                                        <rich:column rowspan="2">
                                            <h:outputText value="Peso<br>Teórico" escape="false"/>
                                        </rich:column>
                                        <rich:column rowspan="2">
                                            <h:outputText value="Tolerancia<br>Volumen<br>Fabricar(%)" escape="false"/>
                                        </rich:column>
                                        <rich:column rowspan="2">
                                            <h:outputText value="Sabor" escape="false"/>
                                        </rich:column>
                                        <rich:column rowspan="2">
                                            <h:outputText value="Nombre Genérico/<br>Concentración" escape="false"/>
                                        </rich:column>
                                        <rich:column rowspan="2">
                                            <h:outputText value="Estado" escape="false"/>
                                        </rich:column>
                                        <rich:column rowspan="2">
                                            <h:outputText value="Nro.<br>Versión" escape="false"/>
                                        </rich:column>
                                        <rich:column rowspan="2">
                                            <h:outputText value="Estado<br> Versión" escape="false"/>
                                        </rich:column>
                                        <rich:column  rowspan="2">
                                            <h:outputText value="Lote(s) asociado(s)" escape="false"/>
                                        </rich:column>
                                        <rich:column rowspan="2">
                                            <h:outputText value="Acciones" escape="false"/>
                                        </rich:column>
                                        <rich:column rowspan="2">
                                            <h:outputText value="Vista<br/>Previa<br/>O.M." escape="false"/>
                                        </rich:column>
                                        <rich:column rowspan="2">
                                            <h:outputText value="Registro<br/>Sanitario" escape="false"/>
                                        </rich:column>
                                        <rich:column breakBefore="true">
                                            <h:outputText value="Registro<br/>Sanitario" escape="false"/>
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="Vida<br/>Util" escape="false"/>
                                        </rich:column>
                                        <rich:column>
                                            <h:outputText value="Fecha Venc.<br/>R.S." escape="false"/>
                                        </rich:column>
                                </rich:columnGroup>
                            </f:facet>
                            <rich:columnGroup >
                                    <rich:column>
                                        <h:outputText value="#{data.nombreProdSemiterminado}" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{data.tamanioLoteProduccion}" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{data.productoSemiterminado?'SI':'NO'}" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{data.areasEmpresa.nombreAreaEmpresa}" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{data.producto.nombreProducto}" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{data.regSanitario}" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{data.vidaUtil}" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{data.fechaVencimientoRS}">
                                            <f:convertDateTime pattern="dd/MM/yyyy"/>
                                        </h:outputText>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{data.forma.nombreForma}" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{data.cantidadVolumen} #{data.unidadMedidaVolumen.abreviatura}" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{data.pesoEnvasePrimario}" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{data.toleranciaVolumenfabricar}" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{data.saboresProductos.nombreSabor}" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{data.concentracionEnvasePrimario}" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{data.estadoCompProd.nombreEstadoCompProd}" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{data.nroVersion}" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{data.estadosVersionComponentesProd.nombreEstadoVersionComponentesProd}" />
                                    </rich:column>
                                    <rich:column>
                                        <a4j:repeat value="#{data.programaProduccionList}" var="lote">
                                            <h:outputText value="#{lote.codLoteProduccion} (#{lote.estadoProgramaProduccion.nombreEstadoProgramaProd}) <br/>" escape="false"/>
                                        </a4j:repeat>
                                    </rich:column>
                                    <rich:column>
                                        
                                        <rich:dropDownMenu rendered="#{ManagedProductosDesarrolloVersion.permisoRegistrarInformacionRegenciaFarmaceutica}">
                                            <f:facet name="label">
                                                <h:panelGroup>
                                                    <h:outputText value="Acciones"/>
                                                    <h:outputText styleClass="icon-menu3"/>
                                                </h:panelGroup>
                                            </f:facet>
                                            <rich:menuItem  submitMode="none"  value="Editar Información" 
                                                            rendered="#{ManagedProductosDesarrolloVersion.permisoRegistrarInformacionRegenciaFarmaceutica}">
                                                <a4j:support event="onclick"  
                                                             oncomplete="redireccionar('editarEnsayoRegencia.jsf')" >
                                                    <f:setPropertyActionListener target="#{ManagedProductosDesarrolloVersion.componentesProdVersion}" value="#{data}"/>
                                                </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuItem icon="../img/subir.png"
                                                           submitMode="none"
                                                           value="Subir Certificado"
                                                           onclick="verRegistroSanitario('#{data.codVersion}');Richfaces.showModalPanel('modalPanelSubirArchivo');">
                                            </rich:menuItem>
                                        </rich:dropDownMenu>
                                        <rich:dropDownMenu rendered="#{( ManagedProductosDesarrolloVersion.permisoGestionEstandarizacionDesarrollo and ManagedProductosDesarrolloVersion.componentesProdSeleccionado.tiposProduccion.codTipoProduccion  eq 3)
                                                                       or ( ManagedProductosDesarrolloVersion.permisoGestionEstandarizacionValidaciones and ManagedProductosDesarrolloVersion.componentesProdSeleccionado.tiposProduccion.codTipoProduccion  eq 4)
                                                                       }" >
                                            <f:facet name="label">
                                                <h:panelGroup>
                                                    <h:outputText value="Acciones"/>
                                                    <h:outputText styleClass="icon-menu3"/>
                                                </h:panelGroup>
                                            </f:facet>
                                            <rich:menuItem  submitMode="none"  value="Editar" >
                                                <a4j:support event="onclick"  
                                                             oncomplete="redireccionar('editarEnsayo.jsf')" >
                                                    <f:setPropertyActionListener target="#{ManagedProductosDesarrolloVersion.componentesProdVersion}" value="#{data}"/>
                                                </a4j:support>
                                            </rich:menuItem>
                                            
                                            
                                            <rich:menuSeparator />
                                            <rich:menuItem value="Debe registrar el tamaño de lote" style="color:red !important" styleClass="outputTexBold"
                                                           rendered="#{data.tamanioLoteProduccion eq 0}"/>
                                            <rich:menuItem  submitMode="none"  value="Materia Prima" icon="/img/MateriaPrima.png"
                                                            rendered="#{data.tamanioLoteProduccion>0}">
                                                <a4j:support event="onclick" 
                                                             action="#{ManagedProductosDesarrolloVersion.seleccionarFormulaMaestraVersionAction}"
                                                             oncomplete="redireccionar('formulaMaestraDesarrollo/formulaMaestraDetalleMP/navegadorFormulaMaestraVersionMP.jsf')" >
                                                    <f:setPropertyActionListener target="#{ManagedProductosDesarrolloVersion.formulaMaestraVersionSelecionado.componentesProd}" value="#{data}"/>
                                                </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuItem  submitMode="none"  value="Empaque Primario" icon="../img/EmpPrim.png"
                                                            rendered="#{data.tamanioLoteProduccion>0}">
                                                <a4j:support event="onclick" 
                                                             action="#{ManagedProductosDesarrolloVersion.seleccionarFormulaMaestraVersionAction}"
                                                             oncomplete="redireccionar('formulaMaestraDesarrollo/formulaMaestraDetalleEP/navegadorFormulaMaestraEP.jsf')" >
                                                    <f:setPropertyActionListener target="#{ManagedProductosDesarrolloVersion.formulaMaestraVersionSelecionado.componentesProd}" value="#{data}"/>
                                                </a4j:support>
                                            </rich:menuItem>
                                            
                                            <rich:menuItem  submitMode="none"  value="Empaque Secundario" icon="../img/EmpSec.png"
                                                            rendered="#{data.tamanioLoteProduccion>0}">
                                                <a4j:support event="onclick" 
                                                             action="#{ManagedProductosDesarrolloVersion.seleccionarFormulaMaestraEsVersionAction}"
                                                             oncomplete="redireccionar('formulaMaestraDesarrollo/formulaMaestraDetalleES/navegadorFormulaMaestraDetalleEsVersion.jsf')" >
                                                    <f:setPropertyActionListener target="#{ManagedProductosDesarrolloVersion.formulaMaestraEsVersionSeleccionado.componentesProdVersion}" value="#{data}"/>
                                                </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuItem  submitMode="none"  value="Material Reactivo" icon="../img/materialReactivo.png"
                                                            rendered="#{data.tamanioLoteProduccion>0}">
                                                <a4j:support event="onclick" 
                                                             action="#{ManagedProductosDesarrolloVersion.seleccionarFormulaMaestraVersionAction}"
                                                             oncomplete="redireccionar('formulaMaestraDesarrollo/formulaMaestraDetalleMR/navegadorFormulaMaestraDetalleMRVersion.jsf')" >
                                                    <f:setPropertyActionListener target="#{ManagedProductosDesarrolloVersion.formulaMaestraVersionSelecionado.componentesProd}" value="#{data}"/>
                                                </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuSeparator />
                                            <rich:menuItem  submitMode="none"  value="Especificaciones Fisicas" icon="../img/EspecificacionesFisicas.png">
                                                <a4j:support event="onclick" 
                                                             oncomplete="redireccionar('especificacionesControlCalidad/especificacionesFisicas.jsf')" >
                                                    <f:setPropertyActionListener target="#{ManagedProductosDesarrolloVersion.componentesProdVersionSeleccionado}" value="#{data}"/>
                                                </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuItem  submitMode="none"  value="Especificaciones Quimicas" icon="../img/EspecificacionesQuimicas.png">
                                                <a4j:support event="onclick" 
                                                             oncomplete="redireccionar('especificacionesControlCalidad/especificacionesQuimicas.jsf')" >
                                                    <f:setPropertyActionListener target="#{ManagedProductosDesarrolloVersion.componentesProdVersionSeleccionado}" value="#{data}"/>
                                                </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuItem  submitMode="none"  value="Especificaciones Microbiologicas" icon="../img/EspecificacionesMicrobiologicas.png">
                                                <a4j:support event="onclick" 
                                                             oncomplete="redireccionar('especificacionesControlCalidad/especificacionesMicrobiologicas.jsf')" >
                                                    <f:setPropertyActionListener target="#{ManagedProductosDesarrolloVersion.componentesProdVersionSeleccionado}" value="#{data}"/>
                                                </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuSeparator/>
                                            <rich:menuItem  submitMode="none"  value="Limpieza Secciones(Producción)">
                                                <a4j:support event="onclick" 
                                                             oncomplete="redireccionar('limpieza/limpiezaSecciones/navegadorLimpiezaSecciones.jsf')" >
                                                    <f:setPropertyActionListener target="#{ManagedProductosDesarrolloVersion.componentesProdVersionSeleccionado}" value="#{data}"/>
                                                </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuItem  submitMode="none"  value="Limpieza Maquinaria">
                                                <a4j:support event="onclick" 
                                                             oncomplete="redireccionar('limpieza/limpiezaMaquinarias/navegadorLimpiezaMaquinaria.jsf')" >
                                                    <f:setPropertyActionListener target="#{ManagedProductosDesarrolloVersion.componentesProdVersionSeleccionado}" value="#{data}"/>
                                                </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuItem  submitMode="none"  value="Limpieza Area Pesaje">
                                                <a4j:support event="onclick" 
                                                             oncomplete="redireccionar('limpieza/limpiezaPesaje/navegadorLimpiezaPesaje.jsf')" >
                                                    <f:setPropertyActionListener target="#{ManagedProductosDesarrolloVersion.componentesProdVersionSeleccionado}" value="#{data}"/>
                                                </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuItem  submitMode="none"  value="Limpieza Utensilios Pesaje">
                                                <a4j:support event="onclick" 
                                                             oncomplete="redireccionar('limpieza/limpiezaPesaje/navegadorLimpiezaUtensiliosPesaje.jsf')" >
                                                    <f:setPropertyActionListener target="#{ManagedProductosDesarrolloVersion.componentesProdVersionSeleccionado}" value="#{data}"/>
                                                </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuSeparator/>
                                            <rich:menuItem  submitMode="none"  value="Procesos Habilitados"
                                                            icon="../img/pasos.jpg">
                                                <a4j:support event="onclick" reRender="contenidoDefinirProcesos"
                                                             oncomplete="Richfaces.showModalPanel('modalDefinirProcesos')" 
                                                             action="#{ManagedProductosDesarrolloVersion.mostrarProcesosOrdenManufacturaAction()}">
                                                    <f:setPropertyActionListener target="#{ManagedProductosDesarrolloVersion.componentesProdVersionSeleccionado}" value="#{data}"/>
                                                </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuItem  submitMode="none"  value="Procesos de Preparado"
                                                            icon="../img/flujoPreparado.jpg">
                                                <a4j:support event="onclick" 
                                                             oncomplete="redireccionar('procesosPreparadoProducto/navegadorProcesosPreparadoProducto.jsf')" >
                                                    <f:setPropertyActionListener target="#{ManagedProductosDesarrolloVersion.componentesProdVersionSeleccionado}" value="#{data}"/>
                                                </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuItem  submitMode="none"  value="Especificaciones Maquinaria"
                                                            icon="../img/maquinaria.jpg">
                                                <a4j:support event="onclick" 
                                                             oncomplete="redireccionar('maquinariasPorProceso/navegadorMaquinariasPorProceso.jsf')" >
                                                    <f:setPropertyActionListener target="#{ManagedProductosDesarrolloVersion.componentesProdVersionSeleccionado}" value="#{data}"/>
                                                </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuItem  submitMode="none"  value="Especificaciones por Proceso"
                                                            icon="../img/granulado.jpg">
                                                <a4j:support event="onclick" 
                                                             oncomplete="redireccionar('especificacionesProcesos/navegadorEspecificacionesProcesos.jsf')" >
                                                    <f:setPropertyActionListener target="#{ManagedProductosDesarrolloVersion.componentesProdVersionSeleccionado}" value="#{data}"/>
                                                </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuItem  submitMode="none"  value="Indicaciones por Proceso"
                                                            icon="../img/indicaciones.jpg">
                                                <a4j:support event="onclick" 
                                                             oncomplete="redireccionar('indicacionesProceso/navegadorIndicacionesProceso.jsf')" >
                                                    <f:setPropertyActionListener target="#{ManagedProductosDesarrolloVersion.componentesProdVersionSeleccionado}" value="#{data}"/>
                                                </a4j:support>
                                            </rich:menuItem>
                                            
                                        </rich:dropDownMenu>
                                    </rich:column>
                                    <rich:column styleClass="tdCenter">
                                        <a4j:commandLink action="#{ManagedProductosDesarrolloVersion.mostrarOrdenManufacturaAction}"
                                                         oncomplete="abrirVentana('../programaProduccion/impresionOrdenManufactura.jsf?codLote=H#{data.codVersion}&codProgramaProd=0&data='+(new Date()).getTime().toString());" >
                                            <h:graphicImage url="../img/OM.jpg"  alt="Orden de Manufactura" />
                                            <f:setPropertyActionListener target="#{ManagedProductosDesarrolloVersion.componentesProdVersionSeleccionado}" value="#{data}"/>
                                        </a4j:commandLink>
                                    </rich:column>
                                    <rich:column styleClass="tdCenter">
                                        <a4j:commandLink oncomplete="abrirVentana('../componentesProdVersion/getRegistroSanitario.jsf?codVersion=#{data.codVersion}');" title="Ver Certificado Sanitario" rendered="#{data.direccionArchivoSanitario !=''}">
                                            <h:graphicImage url="../img/pdf.jpg"/>
                                        </a4j:commandLink>
                                    </rich:column>
                        </rich:columnGroup>
                    </rich:dataTable>
                    <div id="bottonesAcccion" class="barraBotones">
                        <a4j:commandButton value="Crear Nueva Versión"
                                           rendered="#{( ManagedProductosDesarrolloVersion.permisoGestionEstandarizacionDesarrollo and ManagedProductosDesarrolloVersion.componentesProdSeleccionado.tiposProduccion.codTipoProduccion  eq 3)
                                                        or ( ManagedProductosDesarrolloVersion.permisoGestionEstandarizacionValidaciones and ManagedProductosDesarrolloVersion.componentesProdSeleccionado.tiposProduccion.codTipoProduccion  eq 4)}"
                                           action = "#{ManagedProductosDesarrolloVersion.seleccionarUltimaVersionProductoAction}"
                                           oncomplete="Richfaces.showModalPanel('panelCrearNuevoEnsayo')" styleClass="btn"
                                           reRender="contenidoCrearNuevoEnsayo"/>
                        <a4j:commandButton value="Volver" styleClass="btn" oncomplete="redireccionar('navegadorProductosDesarrollo.jsf')"/>
                    </div>
                    <br>
                </div>
               
            </h:form>
            <rich:modalPanel id="panelCrearNuevoEnsayo"  minHeight="170"  minWidth="450"
                            height="170" width="450"
                            zindex="50"
                            headerClass="headerClassACliente"
                            resizeable="false" style="overflow :auto" >
               <f:facet name="header">
                   <h:outputText value="<center>Crear Nueva Versión</center>" escape="false"/>
               </f:facet>
               <a4j:form>
               <h:panelGroup id="contenidoCrearNuevoEnsayo">
                   <div align="center">
                       <h:panelGrid columns="3">
                           <h:outputText value="Nro Ultima Versión" styleClass="outputTextBold"/>
                           <h:outputText value="::" styleClass="outputTextBold"/>
                           <h:outputText value="#{ManagedProductosDesarrolloVersion.componentesProdVersionNuevoEnsayo.nroVersion}" styleClass="outputText2"/>
                           <h:outputText value="Cantidad Lote Ultima Versión" styleClass="outputTextBold"/>
                           <h:outputText value="::" styleClass="outputTextBold"/>
                           <h:outputText value="#{ManagedProductosDesarrolloVersion.componentesProdVersionNuevoEnsayo.tamanioLoteProduccion}" styleClass="outputText2"/>
                           <h:outputText value="Cantidad Lote Nueva Versión" styleClass="outputTextBold"/>
                           <h:outputText value="::" styleClass="outputTextBold"/>
                           <h:inputText value="#{ManagedProductosDesarrolloVersion.nuevoTamanioLote}" styleClass="inputText"/>
                       </h:panelGrid>
                    </div>
               </h:panelGroup>
               <br>
               <div align="center">
                   <a4j:commandButton value="Crear Versión" action="#{ManagedProductosDesarrolloVersion.crearNuevaVersionProductoDesarrolloAction}" 
                                      reRender="dataComponentesProd"
                                      oncomplete="mostrarMensajeTransaccionEvento(function(){Richfaces.hideModalPanel('panelCrearNuevoEnsayo')})" styleClass="btn" />
                   <a4j:commandButton value="Cancelar" oncomplete="Richfaces.hideModalPanel('panelCrearNuevoEnsayo')" styleClass="btn"/>
               </div>
               </a4j:form>
           </rich:modalPanel>
            <rich:modalPanel id="modalPanelSubirArchivo" minHeight="350" headerClass="headerClassACliente"
                                     minWidth="550" height="350" width="700" zindex="100" >
                    <f:facet name="header">
                        <h:outputText value="Subir Certificado de marca"/>
                    </f:facet>
                    <div align="center"  >
                        <iframe src="" id="frameSubir" width="100%" height="300" align="center"></iframe>
                    </div>

            </rich:modalPanel>
            <a4j:include viewId="panelProcesosOrdenManufactura.jsp"/>
            <a4j:include viewId="/panelProgreso.jsp"/>
            <a4j:include viewId="/message.jsp"/>
        </body>
    </html>
    
</f:view>

