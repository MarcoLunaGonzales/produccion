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
            <script type="text/javascript" src="../js/general.js"></script>
            <script type="text/javascript">
                function verificarTransaccionUsuario(codPersonal,celda)
                {
                    var contIndex=parseInt(celda.parentNode.parentNode.rowIndex+1);
                    var permiso=false;
                    var noEnviado=true;
                    if(parseInt(celda.parentNode.parentNode.cells[celda.parentNode.parentNode.cells.length-6].getElementsByTagName("input")[0].value)==codPersonal)
                    {
                        permiso=true;
                        if(parseInt(celda.parentNode.parentNode.cells[celda.parentNode.parentNode.cells.length-5].getElementsByTagName("input")[0].value)!=1)
                        {
                            noEnviado=false;
                        }
                    }

                    while((!permiso)&&celda.parentNode.parentNode.parentNode.parentNode.rows[contIndex]!=null&&celda.parentNode.parentNode.parentNode.parentNode.rows[contIndex].cells.length==6)
                    {
                        if(parseInt(celda.parentNode.parentNode.parentNode.parentNode.rows[contIndex].cells[0].getElementsByTagName("input")[0].value)==codPersonal)
                        {
                            permiso=true;
                            if(parseInt(celda.parentNode.parentNode.parentNode.parentNode.rows[contIndex].cells[1].getElementsByTagName("input")[0].value)!=1)
                            {
                                noEnviado=false;
                            }
                        }
                        contIndex++;
                    }
                    if(!permiso)alert('No se encuentra registrada como personal para modificar la version');
                    if(!noEnviado)alert('No puede realizar cambios ya que su estado es: enviado a aprobación');
                    return (permiso&&noEnviado);
                }
                function validarTransaccionVersion(codPersonal)
                {
                    var tabla=document.getElementById("form1:dataComponentesProdVersion");
                    var indexVersion=0;
                    var countSelect=0;
                    for(var i=3;i<tabla.rows.length;i++)
                    {
                        if(tabla.rows[i].cells.length>2)
                        {
                            if((tabla.rows[i].cells[0].getElementsByTagName("input").length)>0&&tabla.rows[i].cells[0].getElementsByTagName("input")[0].checked)
                            {
                                countSelect++;
                                indexVersion=parseInt(i);
                                seleccionado=tabla.rows[i].cells[1].getElementsByTagName('input')[0].value;
                            }
                        }
                    }
                    if(countSelect>1)
                    {
                        alert('Solo puede seleccionar un registro');
                        return false;
                    }
                    if(countSelect<=0)
                    {
                        alert('No seleccion ningun registro');
                        return false;
                    }
                    return verificarTransaccionUsuario(codPersonal,tabla.rows[indexVersion].cells[0].getElementsByTagName("input")[0]);
                }
                function registrarControlDeCambios(codFormulaMaestraVersion,codCompProdVersion)
                {
                    urlOOS="../controlDeCambios/registroControlCambios.jsf?codFormulaMaestraVersion="+codFormulaMaestraVersion+
                        "&codCompProdVersion="+codCompProdVersion+"&date="+(new Date()).getTime().toString()+"&ale="+Math.random();
                    window.open(urlOOS,'detalle'+Math.round((Math.random()*1000)),'top=50,left=200,width=800,height=600,scrollbars=1,resizable=1');

                }
                function registrarControlCambios()
                {
                    registrarControlDeCambios(0,seleccionado);
                }
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
                var cod=0;
                function openPopup1(url1)
                {

                    izquierda = (screen.width) ? (screen.width-300)/2 : 100
                    arriba = (screen.height) ? (screen.height-400)/2 : 200
                    var url=url1+'&codP='+Math.random();
                     opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,width=700,height=400,left='+izquierda+ ',top=' + arriba + ''
                     cod++;
                    window.open(url,('popUp'+cod),opciones)

                }
                function crearVersion()
                {
                    var tabla=document.getElementById("form1:dataComponentesProdVersion");
                    var countSelect=0;
                    for(var i=3;i<tabla.rows.length;i++)
                    {
                        if(tabla.rows[i].cells.length>2)
                        {
                            if((tabla.rows[i].cells[0].getElementsByTagName("input").length)>0&&tabla.rows[i].cells[0].getElementsByTagName("input")[0].checked)
                            {
                                countSelect++;
                                
                            }
                        }
                    }
                    if(countSelect>1)
                    {
                        alert('Solo puede seleccionar un registro');
                        return false;
                    }
                    if(countSelect<=0)
                    {
                        alert('No seleccion ningun registro');
                        return false;
                    }
                    return true;
                }
                function verReporteComponentesProdVersion(codCompProd,codVersion)
                {
                    var url="reporteComparacionVersionesJasper.jsf?codVersion="+codVersion+"&codCompProd="+codCompProd+"&data="+(new Date()).getTime().toString();
                    openPopup(url);
                }
                function openPopup(url)
                {
                       window.open(url,'detalle'+Math.round((Math.random()*1000)),'top=50,left=200,width=800,height=600,scrollbars=1,resizable=1');
                }
            </script>
        </head>
        <body>
            
            <h:form id="form1"  >                
                <div align="center">                    
                    <a4j:jsFunction name="ok" id="ok"
                                    action="#{ManagedComponentesProdVersion.buscarNuevosComponentesProdVersion_action()}" reRender="dataComponentesProdVersion"/>
                    <h:outputText value="#{ManagedComponentesProdVersion.cargarComponentesProdVersionNuevo}"   />
                    <h:outputText value="Productos Nuevos" styleClass="outputTextTituloSistema"/>
                    
                    <rich:dataTable value="#{ManagedComponentesProdVersion.componentesProdVersionNuevoList}"
                                    var="data" id="dataComponentesProdVersion"
                                    style="margin-top:1em"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';" 
                                    headerClass="headerClassACliente"
                                    binding="#{ManagedComponentesProdVersion.componentesProdVersionNuevoDataTable}"
                                    columnClasses="tituloCampo">
                                <f:facet name="header">
                                    <rich:columnGroup>
                                            <rich:column rowspan="3">
                                                <h:outputText value=""  escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="3">
                                                <h:outputText value="Nombre<br>Producto" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="3">
                                                <h:outputText value="Area<br>Fabricación" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="3">
                                                <h:outputText value="Tipo<br>Modificación<br>Producto" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="3">
                                                <h:outputText value="Nombre<br>Comercial" escape="false"/>
                                            </rich:column>
                                            
                                            <rich:column colspan="3" >
                                                <h:outputText value="Datos Registro Sanitario" escape="false"/>
                                            </rich:column>

                                            <rich:column rowspan="3">
                                                <h:outputText value="Forma<br>Farmaceútica" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="3">
                                                <h:outputText value="Volumen<br>Envase<br>Primario" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="3">
                                                <h:outputText value="Peso<br>Teórico" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="3">
                                                <h:outputText value="Tolerancia<br>Volumen<br>Fabricar(%)" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="3">
                                                <h:outputText value="Sabor" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="3">
                                                <h:outputText value="Concentración" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="3">
                                                <h:outputText value="Estado" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="3">
                                                <h:outputText value="Acciones" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="3">
                                                <h:outputText value="Ver<br>Certificado<br>Pdf" escape="false"/>
                                            </rich:column>
                                            
                                            <rich:column rowspan="3">
                                                <h:outputText value="Cambios<br>Versión" escape="false"/>
                                            </rich:column>
                                            <rich:column colspan="9">
                                                <h:outputText value="Datos Version" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="2" breakBefore="true">
                                                <h:outputText value="Registro<br>Sanitario" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="2" >
                                                <h:outputText value="Vida<br>Util" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="2" >
                                                <h:outputText value="Fecha Venc.<br> R.S." escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="2" >
                                                <h:outputText value="Nro Version"/>
                                            </rich:column>
                                             <rich:column rowspan="2" >
                                                 <h:outputText value="Estado<br>Version" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="2" >
                                                <h:outputText value="Fecha Modificación"/>
                                            </rich:column>
                                            <rich:column colspan="6" >
                                                <h:outputText value="Colaboración"/>
                                            </rich:column>
                                            <rich:column breakBefore="true" >
                                                <h:outputText value="Personal"/>
                                            </rich:column>
                                            <rich:column >
                                                <h:outputText value="Estado<br>Personal" escape="false"/>
                                            </rich:column>
                                            <rich:column >
                                                <h:outputText value="Observación<br>Versión" escape="false"/>
                                            </rich:column>
                                            <rich:column >
                                                <h:outputText value="Fecha<br>Inicio<br>Trabajo" escape="false"/>
                                            </rich:column>
                                            <rich:column >
                                                <h:outputText value="Fecha<br>Envio<br>Aprobación" escape="false"/>
                                            </rich:column>
                                            <rich:column >
                                                <h:outputText value="Fecha<br>Devolución" escape="false"/>
                                            </rich:column>
                                    </rich:columnGroup>
                                </f:facet>
                             <rich:subTable var="subData" value="#{data.componentesProdVersionModificacionList}" rowKeyVar="rowkey">
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:selectBooleanCheckbox value="#{data.checked}" rendered="#{(data.estadosVersionComponentesProd.codEstadoVersionComponenteProd==1||data.estadosVersionComponentesProd.codEstadoVersionComponenteProd==5)&&(ManagedComponentesProdVersion.controlRegistroSanitario||(ManagedComponentesProdVersion.controlNuevoProducto&&data.tiposModificacionProducto.codTipoModificacionProducto eq '1')||(ManagedComponentesProdVersion.controlPresentacionNuevaGenerico &&data.tiposModificacionProducto.codTipoModificacionProducto eq '4'))}"/>
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="#{data.nombreProdSemiterminado}" />
                                         <h:inputHidden value="#{data.codVersion}"/>
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="#{data.areasEmpresa.nombreAreaEmpresa}" />
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="#{data.tiposModificacionProducto.nombreTipoModificacionProducto}" />
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="#{data.producto.nombreProducto}" />
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="#{data.regSanitario}" />
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="#{data.vidaUtil}" />
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="#{data.fechaVencimientoRS}">
                                            <f:convertDateTime pattern="dd/MM/yyyy"/>
                                        </h:outputText>
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="#{data.forma.nombreForma}" />
                                    </rich:column>
                                    
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="#{data.cantidadVolumen} #{data.unidadMedidaVolumen.abreviatura}" />
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="#{data.pesoEnvasePrimario}" />
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="#{data.toleranciaVolumenfabricar}" />
                                    </rich:column>
                                   <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="#{data.saboresProductos.nombreSabor}" />
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="#{data.concentracionEnvasePrimario}" />
                                   </rich:column>
                                   <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="#{data.estadoCompProd.nombreEstadoCompProd}" />
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="Las transacciones para este producto estan deshabilitados por su estado" style="color:red"
                                                      rendered="#{data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 3 || 
                                                                  data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 5 ||
                                                                  data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 7}"/>
                                        <rich:dropDownMenu rendered="#{data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 1 || 
                                                                       data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 9}">
                                            <f:facet name="label">
                                                <h:panelGroup>
                                                    <h:outputText value="Acciones"/>
                                                    <h:outputText styleClass="icon-menu3"/>
                                                </h:panelGroup>
                                            </f:facet>
                                            <rich:menuItem  submitMode="none" iconClass="icon-minus" value="Editar" 
                                                            rendered="#{(data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 33
                                                                            or data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 34
                                                                            or data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 38
                                                                        )
                                                                        and data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 1}">
                                                <a4j:support event="onclick" oncomplete="redireccionar('editarComponentesProdVersion.jsf')">
                                                    <f:setPropertyActionListener target="#{ManagedComponentesProdVersion.componentesProdVersionEditar}" value="#{data}"/>
                                                </a4j:support>
                                            </rich:menuItem>
                                            
                                            <rich:menuItem  submitMode="none"  iconClass="icon-minus" value="Enviar a Aprobacion"
                                                            rendered="#{data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 1}">
                                                <a4j:support event="onclick" reRender="contenidoEnviarAprobacion"
                                                             oncomplete="Richfaces.showModalPanel('modalEnviarAprobacion')">
                                                    <f:setPropertyActionListener target="#{ManagedComponentesProdVersion.componentesProdVersionTransaccion}" value="#{data}"/>
                                                </a4j:support>
                                            </rich:menuItem>
                                            
                                            <rich:menuItem  submitMode="none"  iconClass="icon-minus" value="Observaciones"
                                                            rendered="#{data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 1}">
                                                <a4j:support event="onclick" reRender="contenidoRegistrarObservacion"
                                                             oncomplete="Richfaces.showModalPanel('modalRegistrarObservacion')"
                                                             action="#{ManagedComponentesProdVersion.seleccionarObservarNuevoProductoVersion_action}">
                                                    <f:setPropertyActionListener target="#{ManagedComponentesProdVersion.componentesProdVersionTransaccion}" value="#{data}"/>
                                                </a4j:support>
                                            </rich:menuItem>
                                            
                                            <rich:menuItem  submitMode="none"  iconClass="icon-minus" value="Añadirme a Versión"
                                                            rendered="#{data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 9}">
                                                <a4j:support event="onclick" reRender="contenidoAgregarseVersion"
                                                             oncomplete="Richfaces.showModalPanel('modalAgregarseVersion')">
                                                    <f:setPropertyActionListener target="#{ManagedComponentesProdVersion.componentesProdVersionTransaccion}" value="#{data}"/>
                                                </a4j:support>
                                            </rich:menuItem>
                                            
                                            <rich:menuSeparator />
                                            
                                            <rich:menuItem  rendered="#{data.tamanioLoteProduccion  eq 0}" style="background-color:red !important"  disabled="true"
                                                            value="El producto no tiene asignado tamaño de lote">
                                            </rich:menuItem>
                                            <rich:menuItem  submitMode="none"  iconClass="icon-minus" value="Subir Certificado de R.S(PDF)"
                                                            icon="../img/subir.png"
                                                            rendered="#{data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 33
                                                                        and data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 1}">
                                                <a4j:support event="onclick" reRender="contenidoAgregarseVersion"
                                                             action="#{ManagedComponentesProdVersion.seleccionarFormulaMaestraNuevoVersion_action}"
                                                             oncomplete="verRegistroSanitario('#{data.codVersion}');Richfaces.showModalPanel('modalPanelSubirArchivo')">
                                                    <f:setPropertyActionListener target="#{ManagedComponentesProdVersion.componentesProdVersionTransaccion}" value="#{data}"/>
                                                </a4j:support>
                                            </rich:menuItem>
                                            
                                            <rich:menuItem  submitMode="none"  iconClass="icon-minus" value="Materia Prima"
                                                            icon="../img/MateriaPrima.png"
                                                            rendered="#{(data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 34
                                                                            or data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 38
                                                                        ) 
                                                                        and data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 1
                                                                        and data.tamanioLoteProduccion > 0}">
                                                <a4j:support event="onclick" reRender="contenidoAgregarseVersion"
                                                             action="#{ManagedComponentesProdVersion.seleccionarFormulaMaestraNuevoVersion_action}"
                                                             oncomplete="redireccionar('../formullaMaestraVersiones/formulaMaestraDetalleMP/navegadorFormulaMaestraVersionMP.jsf')">
                                                    <f:setPropertyActionListener target="#{ManagedComponentesProdVersion.componentesProdVersionTransaccion}" value="#{data}"/>
                                                </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuItem  submitMode="none"  iconClass="icon-minus" value="Empaque Primario"
                                                            icon="../img/EmpPrim.png"
                                                            rendered="#{(data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 34
                                                                            or data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 38
                                                                        ) 
                                                                        and data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 1
                                                                        and data.tamanioLoteProduccion > 0}">
                                                <a4j:support event="onclick" reRender="contenidoAgregarseVersion"
                                                             action="#{ManagedComponentesProdVersion.seleccionarFormulaMaestraNuevoVersion_action}"
                                                             oncomplete="redireccionar('../formullaMaestraVersiones/formulaMaestraDetalleEP/navegadorFormulaMaestraEP.jsf')">
                                                    <f:setPropertyActionListener target="#{ManagedComponentesProdVersion.componentesProdVersionTransaccion}" value="#{data}"/>
                                                </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuItem  submitMode="none"  iconClass="icon-minus" value="Empaque Secundario"
                                                            icon="../img/EmpSec.png"
                                                            rendered="#{(data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 34
                                                                            or data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 38
                                                                        ) 
                                                                        and data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 1
                                                                        and data.tamanioLoteProduccion > 0}">
                                                <a4j:support event="onclick" 
                                                             action="#{ManagedComponentesProdVersion.seleccionarComponentesProdNuevoVersionEs_action}"
                                                             oncomplete="redireccionar('../formullaMaestraVersiones/formulaMaestraDetalleES/navegadorFormulaMaestraEsVersion.jsf')">
                                                    <f:setPropertyActionListener target="#{ManagedComponentesProdVersion.componentesProdVersionTransaccion}" value="#{data}"/>
                                                </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuItem  submitMode="none"  iconClass="icon-minus" value="Material Reactivo"
                                                            icon="../img/materialReactivo.png"
                                                            rendered="#{(data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 34
                                                                            or data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 38
                                                                        ) 
                                                                        and data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 1
                                                                        and data.tamanioLoteProduccion > 0}">
                                                <a4j:support event="onclick" 
                                                             action="#{ManagedComponentesProdVersion.seleccionarFormulaMaestraNuevoVersion_action}"
                                                             oncomplete="redireccionar('../formullaMaestraVersiones/formulaMaestraDetalleMR/navegadorFormulaMaestraDetalleMRVersion.jsf')">
                                                    <f:setPropertyActionListener target="#{ManagedComponentesProdVersion.componentesProdVersionTransaccion}" value="#{data}"/>
                                                </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuSeparator />
                                            <rich:menuItem  submitMode="none"  iconClass="icon-minus" value="Especificaciones Fisicas"
                                                            icon="../img/EspecificacionesFisicas.png"
                                                            rendered="#{(data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 34
                                                                            or data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 38
                                                                        ) 
                                                                        and data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 1
                                                                        and data.tamanioLoteProduccion > 0}">
                                                <a4j:support event="onclick" 
                                                             oncomplete="redireccionar('especificacionesControlCalidad/especificacionesFisicas.jsf')">
                                                    <f:setPropertyActionListener target="#{ManagedComponentesProdVersion.componentesProdVersionBean}" value="#{data}"/>
                                                </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuItem  submitMode="none"  iconClass="icon-minus" value="Especificaciones Quimicas"
                                                            icon="../img/EspecificacionesQuimicas.png"
                                                            rendered="#{(data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 34
                                                                            or data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 38
                                                                        ) 
                                                                        and data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 1
                                                                        and data.tamanioLoteProduccion > 0}">
                                                <a4j:support event="onclick" 
                                                             oncomplete="redireccionar('especificacionesControlCalidad/especificacionesQuimicas.jsf')">
                                                    <f:setPropertyActionListener target="#{ManagedComponentesProdVersion.componentesProdVersionBean}" value="#{data}"/>
                                                </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuItem  submitMode="none"  iconClass="icon-minus" value="Especificaciones Microbiologicas"
                                                            icon="../img/EspecificacionesMicrobiologicas.png"
                                                            rendered="#{(data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 34
                                                                            or data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 38
                                                                        ) 
                                                                        and data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 1
                                                                        and data.tamanioLoteProduccion > 0}">
                                                <a4j:support event="onclick" 
                                                             oncomplete="redireccionar('especificacionesControlCalidad/especificacionesMicrobiologicas.jsf')">
                                                    <f:setPropertyActionListener target="#{ManagedComponentesProdVersion.componentesProdVersionBean}" value="#{data}"/>
                                                </a4j:support>
                                            </rich:menuItem>
                                            
                                        </rich:dropDownMenu>
                                        

                                    </rich:column>
                                    
                                     <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0 }" style="text-align:center">
                                        <a4j:commandLink oncomplete="openPopup1('getRegistroSanitario.jsf?codVersion=#{data.codVersion}');" title="Ver Certificado Sanitario" rendered="#{data.direccionArchivoSanitario !=''}">
                                            <h:graphicImage url="../img/pdf.jpg" alt="Ver Certificado"/>
                                        </a4j:commandLink>
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}" style="text-align:center">
                                        <a4j:commandLink oncomplete="verReporteComponentesProdVersion('#{data.codCompprod}','#{data.codVersion}');">
                                            <h:graphicImage url="../img/reporteConsolidado.png" alt="Reporte Consolidado de Versiones"/>
                                        </a4j:commandLink>
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="#{data.nroVersion}" />
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="#{data.estadosVersionComponentesProd.nombreEstadoVersionComponentesProd}" />
                                    </rich:column>
                                    
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="#{data.fechaModificacion}" >
                                            <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                                        </h:outputText>
                                    </rich:column>
                                    <rich:column >
                                        <h:outputText value="#{subData.personal.nombrePersonal}" />
                                        <h:inputHidden value="#{subData.personal.codPersonal}"/>
                                    </rich:column>
                                    <rich:column >
                                        <h:outputText value="#{subData.estadosVersionComponentesProd.nombreEstadoVersionComponentesProd}" />
                                        <h:inputHidden value="#{subData.estadosVersionComponentesProd.codEstadoVersionComponenteProd}" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{subData.observacionPersonalVersion}"/>
                                    </rich:column>
                                    <rich:column >
                                        <h:outputText value="#{subData.fechaInclusionVersion}">
                                            <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                                        </h:outputText>
                                    </rich:column>
                                    <rich:column >
                                        <h:outputText value="#{subData.fechaEnvioAprobacion}">
                                            <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                                        </h:outputText>
                                    </rich:column>
                                    <rich:column >
                                        <h:outputText value="#{subData.fechaDevolucionVersion}">
                                            <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                                        </h:outputText>
                                    </rich:column>
                            </rich:subTable>
                    </rich:dataTable>
                    <br>
                    <a4j:commandButton rendered="#{ManagedComponentesProdVersion.controlRegistroSanitario}" value="Agregar Nuevo"
                                        oncomplete="window.location.href='agregarNuevoComponenteProdVersion.jsf?data='+(new Date()).getTime().toString();" styleClass="btn"/>
                    
                </div>
            </h:form>
            
            <rich:modalPanel id="modalAgregarseVersion" minHeight="200" headerClass="headerClassACliente"
                                     minWidth="390" height="200" width="390" zindex="100" >
                    <f:facet name="header">
                        <h:outputText value="<center>Añadirse a versión</center>" escape="false"/>
                    </f:facet>
                <a4j:form id="contenidoAgregarseVersion">
                    <center>
                        <h:outputText value="Esta seguro de añadirse a la versión?" styleClass="outputText2"/>
                        <br/>
                        <h:panelGrid columns="3">
                            <h:outputText value="Producto" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionTransaccion.nombreProdSemiterminado}" styleClass="outputText2"/>
                            <h:outputText value="Nombre Comercial" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionTransaccion.producto.nombreProducto}" styleClass="outputText2"/>
                        </h:panelGrid>
                        <br/>
                        <a4j:commandButton value="Añadirme a versión" styleClass="btn" action="#{ManagedComponentesProdVersion.agregarPersonalNuevoProducto_action}" 
                                           reRender="dataComponentesProdVersion"
                                           oncomplete="if(#{ManagedComponentesProdVersion.mensaje eq '1'}){alert('Se registro la transccion');Richfaces.hideModalPanel('modalAgregarseVersion');}else{alert('#{ManagedComponentesProdVersion.mensaje}')}"/>
                        <a4j:commandButton value="Cancelar" styleClass="btn" oncomplete="Richfaces.hideModalPanel('modalAgregarseVersion')"/>
                    </center>
                </a4j:form>
            </rich:modalPanel>
            <rich:modalPanel id="modalEnviarAprobacion" minHeight="200" headerClass="headerClassACliente"
                                     minWidth="390" height="200" width="390" zindex="100" >
                    <f:facet name="header">
                        <h:outputText value="<center>Enviar a Aprobación</center>" escape="false"/>
                    </f:facet>
                <a4j:form id="contenidoEnviarAprobacion">
                    <center>
                        <h:outputText value="Esta seguro de enviar a aprobación el siguiente producto?" styleClass="outputText2"/>
                        <br/>
                        <h:panelGrid columns="3">
                            <h:outputText value="Producto" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionTransaccion.nombreProdSemiterminado}" styleClass="outputText2"/>
                            <h:outputText value="Nombre Comercial" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionTransaccion.producto.nombreProducto}" styleClass="outputText2"/>
                        </h:panelGrid>
                        <br/>
                        <a4j:commandButton value="Enviar a aprobación" styleClass="btn" action="#{ManagedComponentesProdVersion.enviarAAprobacionNuevoProducto_action}"
                                           oncomplete="if(#{ManagedComponentesProdVersion.mensaje eq '1'}){alert('Se envio la versión a aprobación');Richfaces.hideModalPanel('modalEnviarAprobacion')}
                                           else {alert('#{ManagedComponentesProdVersion.mensaje}')}" reRender="dataComponentesProdVersion"/>
                        <a4j:commandButton value="Cancelar" styleClass="btn" oncomplete="Richfaces.hideModalPanel('modalEnviarAprobacion')"/>
                    </center>
                </a4j:form>
            </rich:modalPanel>
            
            <rich:modalPanel id="modalPanelSubirArchivo" minHeight="300" headerClass="headerClassACliente"
                                     minWidth="550" height="300" width="700" zindex="100" >
                    <f:facet name="header">
                        <h:outputText value="Subir Certificado de Registro Sanitario"/>
                    </f:facet>
                        <div align="center"  >
                            <iframe src="" id="frameSubir" width="100%" height="250px" align="center"></iframe>
                        </div>

            </rich:modalPanel>
            <rich:modalPanel id="modalRegistrarObservacion" minHeight="230" headerClass="headerClassACliente"
                             minWidth="550" height="230" width="700" zindex="100" >
                    <f:facet name="header">
                        <h:outputText value="<center>Registrar Observación</center>" escape="false"/>
                    </f:facet>
                    <a4j:form>
                        <center>
                            <h:panelGroup id="contenidoRegistrarObservacion">
                                <h:panelGrid columns="3">
                                    <h:outputText value="Producto" styleClass="outputTextBold"/>
                                    <h:outputText value="::" styleClass="outputTextBold"/>
                                    <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.nombreProdSemiterminado}" styleClass="outputText2"/>
                                    <h:outputText value="Nombre Comercial" styleClass="outputTextBold"/>
                                    <h:outputText value="::" styleClass="outputTextBold"/>
                                    <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.producto.nombreProducto}" styleClass="outputText2"/>
                                    <h:outputText value="Nro Versión" styleClass="outputTextBold"/>
                                    <h:outputText value="::" styleClass="outputTextBold"/>
                                    <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.nroVersion}" styleClass="outputText2"/>
                                    <h:outputText value="Observación" styleClass="outputTextBold"/>
                                    <h:outputText value="::" styleClass="outputTextBold"/>
                                    <h:inputTextarea style="width:40em" value="#{ManagedComponentesProdVersion.componentesProdVersionModificacionObservar.observacionPersonalVersion}" styleClass="inputText" rows="4"/>
                                </h:panelGrid>
                            </h:panelGroup>
                            <a4j:commandButton action="#{ManagedComponentesProdVersion.guardarObservacionPersonalVersion}" 
                                               oncomplete="if(#{ManagedComponentesProdVersion.mensaje eq '1'}){alert('Se registro la observación');Richfaces.hideModalPanel('modalRegistrarObservacion');}else{alert('#{ManagedComponentesProdVersion.mensaje}');}"
                                               reRender="dataComponentesProdVersion"
                                               styleClass="btn" value="Guardar Observación"/>
                            <a4j:commandButton value="Cancelar" styleClass="btn" oncomplete="Richfaces.hideModalPanel('modalRegistrarObservacion')"/>
                    </center>
                                           
                    </a4j:form>
                
            </rich:modalPanel>
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

