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
            <script type="text/javascript" src="../js/general.js"></script>
            <script type="text/javascript">
                function verificarTransaccionUsuario(codPersonal,celda)
                {
                    var contIndex=parseInt(celda.parentNode.parentNode.rowIndex+1);
                    var permiso=false;
                    var noEnviado=true;
                    if(parseInt(celda.parentNode.parentNode.cells[celda.parentNode.parentNode.cells.length-5].getElementsByTagName("input")[0].value)==codPersonal)
                    {
                        permiso=true;
                         if(parseInt(celda.parentNode.parentNode.cells[celda.parentNode.parentNode.cells.length-4].getElementsByTagName("input")[0].value)!=1)
                       {
                            noEnviado=false;
                       }
                    }

                    while((!permiso)&&celda.parentNode.parentNode.parentNode.parentNode.rows[contIndex]!=null&&celda.parentNode.parentNode.parentNode.parentNode.rows[contIndex].cells.length==5)
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
                    var url=url1+'?codP='+Math.random();
                     opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,width=700,height=400,left='+izquierda+ ',top=' + arriba + ''
                     cod++;
                    window.open("certificadosPdf/"+url,('popUp'+cod),opciones)

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
                    var url="reporteComparacionVersiones.jsf?codVersion="+codVersion+"&codCompProd="+codCompProd+"&data="+(new Date()).getTime().toString();
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
                    action="#{ManagedComponentesProdVersion.buscarNuevosComponentesProdVersion_action}" reRender="dataComponentesProdVersion"/>
                    <h:outputText value="#{ManagedComponentesProdVersion.cargarComponentesProdVersionNuevosTamaniosLoteProduccion}"   />
                    <h:outputText value="Nuevos Tamanios de Lotes de Produccion" styleClass="outputTextTituloSistema"/>
                    
                    <rich:dataTable value="#{ManagedComponentesProdVersion.componentesProdVersionNuevosTamaniosLoteProduccion}"
                                    var="data" id="dataComponentesProdVersion"
                                    style="margin-top:1em"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';" 
                                    headerClass="headerClassACliente"
                                    binding="#{ManagedComponentesProdVersion.componentesProdVersionNuevosTamaniosDataTable}"
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
                                                <h:outputText value="Nombre<br>Comercial" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="3">
                                                <h:outputText value="Tamaño<br>Lote<br>Producción" escape="false"/>
                                            </rich:column>
                                            <rich:column colspan="3" >
                                                <h:outputText value="Datos Registro Sanitario" escape="false"/>
                                            </rich:column>

                                            <rich:column rowspan="3">
                                                <h:outputText value="Forma<br>Farmaceútica" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="3">
                                                <h:outputText value="Color<br>Presentacion<br>Primaria" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="3">
                                                <h:outputText value="Via<br>Administración" escape="false"/>
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
                                                <h:outputText value="Tamaño<br>Capsula" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="3">
                                                <h:outputText value="Concentración" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="3">
                                                <h:outputText value="Condición<br>Venta" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="3">
                                                <h:outputText value="Estado" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="3" rendered="#{ManagedComponentesProdVersion.controlRegistroSanitario}">
                                                <h:outputText value="Subir<br>Certificado<br>Pdf" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="3" rendered="#{ManagedComponentesProdVersion.controlRegistroSanitario}">
                                                <h:outputText value="Ver<br>Certificado<br>Pdf" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="3"   style="text-align:center">
                                                <h:outputText value="Acciones" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="3"   style="text-align:center">
                                                <h:outputText value="Empaque<br>Secundario" escape="false"/>
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
                                            <rich:column>
                                                <h:outputText value="Fecha<br/>Asignación" escape="false"/>
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
                                        <h:selectBooleanCheckbox value="#{data.checked}" rendered="#{data.estadosVersionComponentesProd.codEstadoVersionComponenteProd==1||data.estadosVersionComponentesProd.codEstadoVersionComponenteProd==5}"/>
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="#{data.nombreProdSemiterminado}" />
                                         <h:inputHidden value="#{data.codVersion}"/>
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="#{data.areasEmpresa.nombreAreaEmpresa}" />
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="#{data.producto.nombreProducto}" />
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="#{data.tamanioLoteProduccion}" />
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
                                        <h:outputText value="#{data.coloresPresentacion.nombreColor}" />
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="#{data.viasAdministracionProducto.nombreViaAdministracionProducto}" />
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
                                        <h:outputText value="#{data.tamaniosCapsulasProduccion.nombreTamanioCapsulaProduccion}" />
                                    </rich:column>
                                   <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="#{data.concentracionEnvasePrimario}" />
                                   </rich:column>
                                   <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="#{data.condicionesVentasProducto.nombreCondicionVentaProducto}" />
                                   </rich:column>
                                   <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="#{data.estadoCompProd.nombreEstadoCompProd}" />
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  
                                                 rendered="#{ManagedComponentesProdVersion.controlRegistroSanitario&&rowkey eq 0 }" style="text-align:center">
                                        <h:outputText value="<a style='cursor:hand' onclick=\"if(verificarTransaccionUsuario('#{ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal}',this)){verRegistroSanitario('#{data.codVersion}');Richfaces.showModalPanel('modalPanelSubirArchivo');}else{return false;}\"><img alt='Subir PDF' src='../img/subir.png'  /></a>"
                                        rendered="#{data.estadosVersionComponentesProd.codEstadoVersionComponenteProd==1||data.estadosVersionComponentesProd.codEstadoVersionComponenteProd==5}" escape="false"/>
                                        
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"
                                                 rendered="#{rowkey eq 0}">
                                        <rich:dropDownMenu>
                                            <f:facet name="label">
                                                <h:panelGroup>
                                                    <h:outputText value="Acciones"/>
                                                    <h:outputText styleClass="icon-menu3"/>
                                                </h:panelGroup>
                                            </f:facet>
                                            <%--rich:menuItem  submitMode="none" value="Registrar Observaciones"  
                                                            rendered="#{data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 1}">
                                                <a4j:support event="onclick" reRender="contenidoRegistrarObservacion"
                                                             oncomplete="Richfaces.showModalPanel('modalRegistrarObservacion')"
                                                             action="#{ManagedComponentesProdVersion.seleccionarObservarVersion_action()}" >
                                                    <f:setPropertyActionListener target="#{ManagedComponentesProdVersion.componentesProdVersionBean}"
                                                                                                value="#{data}"/>
                                                </a4j:support>
                                            </rich:menuItem--%>
                                            <rich:menuItem  submitMode="none" value="Asignación de Personal"  
                                                            rendered="#{ManagedComponentesProdVersion.permisoCreacionVersion
                                                                            and (data.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 1
                                                                                    or data.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 5)}">
                                                <a4j:support event="onclick" reRender="formPersonalVersion"
                                                             oncomplete="Richfaces.showModalPanel('panelPersonalVersion')"
                                                             action="#{ManagedComponentesProdVersion.seleccionarCargarPersonalModificacionVersionAction()}" >
                                                    <f:setPropertyActionListener target="#{ManagedComponentesProdVersion.componentesProdVersionEditar}"
                                                                                                value="#{data}"/>
                                                </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuItem  rendered="#{data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 9}"
                                                            submitMode="none" value="Añadirme a Versión">
                                                    <a4j:support event="onclick" 
                                                                 oncomplete="if(#{ManagedComponentesProdVersion.mensaje eq '1'}){alert('Se añadio satisfactoriamente a la version');/*registrarControlCambios();*/}else{alert('#{ManagedComponentesProdVersion.mensaje}')}"
                                                                 reRender="dataComponentesProdVersion"
                                                                 action="#{ManagedComponentesProdVersion.agregarPersonalComponentesProdVersionTamaniosLoteProduccion()}">
                                                        <f:setPropertyActionListener value="#{data}" target="#{ManagedComponentesProdVersion.componentesProdVersionBean}"/>
                                                    </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuItem  rendered="#{data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 9}"
                                                            submitMode="none" value="Sin necesidad de Cambios">
                                                    <a4j:support event="onclick" 
                                                                 oncomplete="if(#{ManagedComponentesProdVersion.mensaje eq '1'}){alert('Se registro como sin necesidad de cambios');/*registrarControlCambios();*/}else{alert('#{ManagedComponentesProdVersion.mensaje}')}"
                                                                 reRender="dataComponentesProdVersion"
                                                                 action="#{ManagedComponentesProdVersion.sinNecesidadDeCambiosComponentesProdVersionTamanioLoteProduccion()}">
                                                        <f:setPropertyActionListener value="#{data}" target="#{ManagedComponentesProdVersion.componentesProdVersionBean}"/>
                                                    </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuItem  rendered="#{data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 1}"
                                                            submitMode="none" value="Enviar a Aprobación">
                                                    <a4j:support event="onclick" 
                                                                 oncomplete="if(#{ManagedComponentesProdVersion.mensaje eq '1'}){alert('Se envio la version a aprobación');/*registrarControlCambios();*/}else{alert('#{ManagedComponentesProdVersion.mensaje}')}"
                                                                 reRender="dataComponentesProdVersion"
                                                                 action="#{ManagedComponentesProdVersion.enviarAprobacionNuevoTamanioLoteProduccionAction}">
                                                        <f:setPropertyActionListener value="#{data}" target="#{ManagedComponentesProdVersion.componentesProdVersionBean}"/>
                                                    </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuItem  rendered="#{data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 1 
                                                                        and data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 34}"
                                                            submitMode="none" value="Eliminar">
                                                    <a4j:support event="onclick" 
                                                                 oncomplete="if(#{ManagedComponentesProdVersion.mensaje eq '1'}){alert('Se elimino satisfactoriamente la versión');/*registrarControlCambios();*/}else{alert('#{ManagedComponentesProdVersion.mensaje}')}"
                                                                 reRender="dataComponentesProdVersion"
                                                                 action="#{ManagedComponentesProdVersion.eliminarComponentesProdVersionTamaniosLoteProduccion()}">
                                                        <f:setPropertyActionListener value="#{data}" target="#{ManagedComponentesProdVersion.componentesProdVersionBean}"/>
                                                    </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuSeparator/>
                                            <rich:menuItem  rendered="#{data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 1
                                                                        and (data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 33
                                                                                or data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 34)}"
                                                            submitMode="ajax"
                                                            oncomplete="redireccionar('editarComponentesProdVersion.jsf')">
                                                    <h:outputText value="Editar"/>
                                                    <f:setPropertyActionListener value="#{data}" target="#{ManagedComponentesProdVersion.componentesProdVersionEditar}"/>
                                            </rich:menuItem>
                                            <rich:menuSeparator/>
                                            <rich:menuItem  submitMode="none" value="Materia Prima" icon="../img/MateriaPrima.png"
                                                            rendered="#{data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 1
                                                                            and data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 34}" >
                                                <a4j:support event="onclick"
                                                             oncomplete="redireccionar('../formullaMaestraVersiones/formulaMaestraDetalleMP/navegadorFormulaMaestraVersionMP.jsf')"
                                                             action="#{ManagedComponentesProdVersion.seleccionarFormulaMaestraNuevoTamanioLote_action}" >
                                                </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuItem  submitMode="none" value="Empaque Primario" icon="../img/EmpPrim.png"
                                                            rendered="#{data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 1
                                                                            and data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 34}" >
                                                <a4j:support event="onclick"
                                                             oncomplete="redireccionar('../formullaMaestraVersiones/formulaMaestraDetalleEP/navegadorFormulaMaestraEP.jsf')"
                                                             action="#{ManagedComponentesProdVersion.seleccionarFormulaMaestraNuevoTamanioLote_action}" >
                                                </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuSeparator/>
                                            <rich:menuItem  submitMode="none" value="Material Reactivo" icon="../img/materialReactivo.png"
                                                            rendered="#{data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 1
                                                                            and data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 35}" >
                                                <a4j:support event="onclick"
                                                             oncomplete="redireccionar('../formullaMaestraVersiones/formulaMaestraDetalleMR/navegadorFormulaMaestraDetalleMRVersion.jsf')"
                                                             action="#{ManagedComponentesProdVersion.seleccionarFormulaMaestraNuevoTamanioLote_action}" >
                                                </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuSeparator/>
                                            <rich:menuItem value="Especificaciones de C.C." disabled="true"/>
                                            <rich:menuItem  submitMode="none" value="Especificaciones Fisicas " icon="../img/EspecificacionesFisicas.png"
                                                            rendered="#{data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 1
                                                                            and data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 35}" >
                                                <a4j:support event="onclick"
                                                             oncomplete="redireccionar('especificacionesControlCalidad/especificacionesFisicas.jsf')"
                                                             action="#{ManagedComponentesProdVersion.seleccionarComponentesProdVersionNuevoTamanioLote_action}" >
                                                </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuItem  submitMode="none" value="Especificaciones Quimicas" icon="../img/EspecificacionesQuimicas.png"
                                                            rendered="#{data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 1
                                                                            and data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 35}" >
                                                <a4j:support event="onclick"
                                                             oncomplete="redireccionar('especificacionesControlCalidad/especificacionesQuimicas.jsf')"
                                                             action="#{ManagedComponentesProdVersion.seleccionarComponentesProdVersionNuevoTamanioLote_action}" >
                                                </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuItem  submitMode="none" value="Especificaciones Microbiologicas " icon="../img/EspecificacionesMicrobiologicas.png"
                                                            rendered="#{data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 1
                                                                            and data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 35}" >
                                                <a4j:support event="onclick"
                                                             oncomplete="redireccionar('especificacionesControlCalidad/especificacionesMicrobiologicas.jsf')"
                                                             action="#{ManagedComponentesProdVersion.seleccionarComponentesProdVersionNuevoTamanioLote_action}" >
                                                </a4j:support>
                                            </rich:menuItem>
                                         </rich:dropDownMenu>
                                    </rich:column>
                                     <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{ManagedComponentesProdVersion.controlRegistroSanitario && rowkey eq 0 }" style="text-align:center">
                                         <a4j:commandLink oncomplete="abrirVentana('getRegistroSanitario.jsf?codVersion=#{data.codVersion}');" title="Ver Certificado Sanitario" rendered="#{data.direccionArchivoSanitario !=''}">
                                            <h:graphicImage url="../img/pdf.jpg" alt="Ver Certificado"/>
                                         </a4j:commandLink>
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}" style="text-align:center">
                                        <a4j:commandLink action="#{ManagedComponentesProdVersion.seleccionarComponentesProdNuevoTamanioLoteVersionEs_action}" rendered="#{data.estadosVersionComponentesProd.codEstadoVersionComponenteProd==1||data.estadosVersionComponentesProd.codEstadoVersionComponenteProd==5}"
                                        oncomplete="window.location.href='../formullaMaestraVersiones/formulaMaestraDetalleES/navegadorFormulaMaestraEsVersion.jsf?data='+(new Date()).getTime().toString();">
                                            <h:graphicImage url="../img/EmpSec.png" alt="Empaque Secundario"/>
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
                                        <h:outputText value="#{subData.personal.nombreCompletoPersonal}" />
                                        <h:inputHidden value="#{subData.personal.codPersonal}"/>
                                    </rich:column>
                                    <rich:column >
                                        <h:outputText value="#{subData.estadosVersionComponentesProd.nombreEstadoVersionComponentesProd}" />
                                        <h:inputHidden value="#{subData.estadosVersionComponentesProd.codEstadoVersionComponenteProd}" />
                                    </rich:column>
                                    <rich:column >
                                        <h:outputText value="#{subData.fechaAsignacion}">
                                            <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                                        </h:outputText>
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
                </div>
            </h:form>
            <a4j:include viewId="panelVersionModificacion.jsp" id="panelVersionModificacion"/>
            <a4j:include viewId="/message.jsp"/>
            <a4j:include viewId="/panelProgreso.jsp"/>
        </body>
    </html>
    
</f:view>

