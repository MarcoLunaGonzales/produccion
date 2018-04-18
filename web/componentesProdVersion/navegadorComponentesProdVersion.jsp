<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <script type="text/javascript" src="../js/general.js"></script>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <link rel="STYLESHEET" type="text/css" href="../css/icons.css" />
            <link rel="STYLESHEET" type="text/css" href="../css/chosen.css" />
            <style>
                .enProceso
                {
                    background-color:#c9fdc9;
                }
                .enviadoAprobacion
                {
                    background-color:#fac5af;
                }
            </style>
            <script>
                function verReporteComponentesProdVersion(codCompProd,codVersion)
                {
                    var url="reporteComparacionVersionesJasper.jsf?codVersion="+codVersion+"&codCompProd="+codCompProd+"&data="+(new Date()).getTime().toString();
                    openPopup(url);
                }
                function openPopup(url)
                {
                       window.open(url,'detalle'+Math.round((Math.random()*1000)),'top=50,left=200,width=800,height=600,scrollbars=1,resizable=1');
                }
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
                var seleccionado=0;
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
                    var a=(new Date()).getTime().toString();
                    document.getElementById('frameSubir').src="subirArchivoPdf.jsf?codVersion="+codVersion+"&a="+a;
                }
                function ocultaRegistro()
                {
                    Richfaces.hideModalPanel('modalPanelSubirArchivo');
                }
                function verCopiaControlada(url1)
                {
                    izquierda = (screen.width) ? (screen.width-300)/2 : 100
                    arriba = (screen.height) ? (screen.height-400)/2 : 200
                    var url='certificadosPdf/'+url1+'?date='+(new Date()).getTime().toString();
                     opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,width=700,height=400,left='+izquierda+ ',top=' + arriba + ''
                     contPopup++;
                    window.open(url, ('popUp'+contPopup),opciones);
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
                function validarGuardarHabilitacionProcesosPreparado()
                {
                    var tabla=document.getElementById("formProcesos:dataProcesosOm").getElementsByTagName("tbody")[0];
                    var cantidadDeRegistros=0;
                    for(var i=0;i<tabla.rows.length;i++)
                    {
                        if(tabla.rows[i].cells[0].getElementsByTagName("input")[0].checked)
                        {
                            cantidadDeRegistros++;
                            if(!validarMayorACero(tabla.rows[i].cells[1].getElementsByTagName("input")[0]))
                            {
                                return false;
                            }
                        }
                    }
                    return true;
                }
                
            </script>
        </head>
        
            <a4j:form id="form1">                
                <div align="center">                    
                    <a4j:jsFunction name="ok" id="ok" action="#{ManagedComponentesProdVersion.buscarComponentesProdVersion_action}" reRender="dataComponentesProdVersion"/>
                    <h:outputText value="#{ManagedComponentesProdVersion.cargarComponentesProdVersion}"   />
                    <h:outputText value="Versiones de Producto" styleClass="outputTextTituloSistema"/>
                    <rich:panel headerClass="headerClassACliente" style="width:80%">
                        <f:facet name="header">
                            <h:outputText value="Datos Version Oficial"/>
                        </f:facet>
                        <h:panelGrid columns="6">
                            <h:outputText value="Nombre Producto" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedComponentesProdVersion.componentesProdBean.nombreProdSemiterminado}" styleClass="outputText2"/>
                            <h:outputText value="Nombre Comercial" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedComponentesProdVersion.componentesProdBean.producto.nombreProducto}" styleClass="outputText2"/>
                            <h:outputText value="Nombre Generico" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedComponentesProdVersion.componentesProdBean.nombreGenerico}" styleClass="outputText2"/>
                            <h:outputText value="Area Fabricación" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedComponentesProdVersion.componentesProdBean.areasEmpresa.nombreAreaEmpresa}" styleClass="outputText2"/>
                            <h:outputText value="Forma Farmaceútica" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedComponentesProdVersion.componentesProdBean.forma.nombreForma}" styleClass="outputText2"/>
                            <h:outputText value="Información Completa del producto" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedComponentesProdVersion.componentesProdBean.informacionCompleta ? 'SI' : 'NO'}" styleClass="outputText2"/>
                        </h:panelGrid>
                    </rich:panel>
                    <br/>
                    <a4j:commandButton reRender="contenidoCrearVersion"
                                         styleClass="btn" 
                                         action="#{ManagedComponentesProdVersion.agregarNuevaVersionAction}"
                                        oncomplete="Richfaces.showModalPanel('panelCrearNuevaVersion')"
                                        value="Crear Nueva Versión"
                                        rendered="#{ManagedComponentesProdVersion.componentesProdBean.estadoCompProd.codEstadoCompProd ne 3
                                                        and ManagedComponentesProdVersion.permisoCreacionVersion}"/>
                    <h:outputText value="No se pueden crear nuevas versiones mientras el producto se encuentre en estandarización"
                                  styleClass="message" 
                                  rendered="#{ManagedComponentesProdVersion.componentesProdBean.estadoCompProd.codEstadoCompProd eq 3  and ManagedComponentesProdVersion.controlPresentacionPrimaria}"/>
                    <rich:dataTable value="#{ManagedComponentesProdVersion.componentesProdVersionList}"
                                    var="data" id="dataComponentesProdVersion"
                                    style="margin-top:1em"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';" 
                                    headerClass="headerClassACliente"
                                    binding="#{ManagedComponentesProdVersion.componentesProdVersionDataTable}"
                                    columnClasses="tituloCampo">
                            
                                <f:facet name="header">
                                    <rich:columnGroup>
                                            <rich:column rowspan="3">
                                                <h:outputText value="Nombre<br>Producto" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="3">
                                                <h:outputText value="Producto<br>Semi-Elaborado" escape="false"/>
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
                                            <rich:column rowspan="3" >
                                                <h:outputText value="Ver<br>Certificado<br>Pdf" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="3" >
                                                <h:outputText value="Acciones" escape="false"/>
                                            </rich:column>
                                            
                                            <rich:column rowspan="3" rendered="#{ManagedComponentesProdVersion.controlPresentacionPrimaria }" style="text-align:center">
                                                <h:outputText value="Materia<br>Prima" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="3" rendered="#{ManagedComponentesProdVersion.controlPresentacionPrimaria }" style="text-align:center">
                                                <h:outputText value="Empaque<br>Primario" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="3"  style="text-align:center">
                                                <h:outputText value="Empaque<br>Secundario" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="3" rendered="#{ManagedComponentesProdVersion.controlPresentacionPrimaria}">
                                                <h:outputText value="Procesos<br> habilitados"  escape="false" />
                                            </rich:column>
                                            <rich:column rowspan="3" rendered="#{ManagedComponentesProdVersion.controlPresentacionPrimaria}">
                                                <h:outputText value="Limpieza"  escape="false" />
                                            </rich:column>
                                            <rich:column rowspan="3" rendered="#{ManagedComponentesProdVersion.controlPresentacionPrimaria}">
                                                <h:outputText value="Flujo de<br> preparado"  escape="false" />
                                            </rich:column>
                                            <rich:column rowspan="3" rendered="#{ManagedComponentesProdVersion.controlPresentacionPrimaria}">
                                                <h:outputText value="Filtros de<br> producción"  escape="false" />
                                            </rich:column>
                                            <rich:column rowspan="3" rendered="#{ManagedComponentesProdVersion.controlPresentacionPrimaria}">
                                                <h:outputText value="Especificaciones de<br> maquinaria<br> por proceso"  escape="false" />
                                            </rich:column>
                                            <rich:column rowspan="3" rendered="#{ManagedComponentesProdVersion.controlPresentacionPrimaria}">
                                                <h:outputText value="Especificaciones <br>por proceso"  escape="false" />
                                            </rich:column>
                                            <rich:column rowspan="3" rendered="#{ManagedComponentesProdVersion.controlPresentacionPrimaria}">
                                                <h:outputText value="Indicaciones<br>por proceso"  escape="false" />
                                            </rich:column>
                                            <rich:column rowspan="3" rendered="#{ManagedComponentesProdVersion.controlPresentacionPrimaria}">
                                                <h:outputText value="Documentación<br> Aplicada"  escape="false" />
                                            </rich:column>
                                            
                                            <rich:column rowspan="3" rendered="#{ManagedComponentesProdVersion.controlPresentacionPrimaria }">
                                                <h:outputText value="Orden<br>Manufactura" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="3" rendered="#{ManagedComponentesProdVersion.controlPresentacionPrimaria }">
                                                <h:outputText value="Etiquetas" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="3">
                                                <h:outputText value="Cambios<br>Versión" escape="false"/>
                                            </rich:column>
                                            <rich:column colspan="11">
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
                                            <rich:column rowspan="2" >
                                                <h:outputText value="Fecha Inicio Vigencia"/>
                                            </rich:column>
                                            <rich:column colspan="7" >
                                                <h:outputText value="Colaboración"/>
                                            </rich:column>
                                            <rich:column breakBefore="true" >
                                                <h:outputText value="Personal"/>
                                            </rich:column>
                                            <rich:column >
                                                <h:outputText value="Estado<br>Personal" escape="false"/>
                                            </rich:column>
                                            <rich:column >
                                                <h:outputText value="Observación<br>Version" escape="false"/>
                                            </rich:column>
                                            <rich:column >
                                                <h:outputText value="Fecha<br>Asignación" escape="false"/>
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
                                 <rich:columnGroup styleClass="#{(data.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 1 or
                                                                    data.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 5 ? 'enProceso' :
                                                                        (data.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 3 ? 'enviadoAprobacion' : ''))}">
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="#{data.nombreProdSemiterminado}" />
                                        <h:outputText value="<br/>La version tiene #{data.cantidadLotesConDesviacion} lote(s) con desviación(es) planificada(s)" style="color:red" 
                                                      rendered="#{data.cantidadLotesConDesviacion > 0}" escape="false"/>
                                         <h:inputHidden value="#{data.codVersion}"/>
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                    <h:outputText value="#{data.productoSemiterminado?'SI':'NO'}" />
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="#{data.areasEmpresa.nombreAreaEmpresa}" />
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="#{data.nombreComercial}" />
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
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{ManagedComponentesProdVersion.controlRegistroSanitario && rowkey eq 0 }" style="text-align:center">
                                        <h:outputText value="<a style='cursor:hand' onclick=\"verRegistroSanitario('#{data.codVersion}');Richfaces.showModalPanel('modalPanelSubirArchivo');\"><img alt='Subir PDF' src='../img/subir.png'  /></a>"
                                        rendered="#{data.estadosVersionComponentesProd.codEstadoVersionComponenteProd==1||data.estadosVersionComponentesProd.codEstadoVersionComponenteProd==5}" escape="false"/>
                                        
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0 }" style="text-align:center">
                                        <a4j:commandLink oncomplete="openPopup1('getRegistroSanitario.jsf?codVersion=#{data.codVersion}');" title="Ver Certificado Sanitario" rendered="#{data.direccionArchivoSanitario !=''}">
                                            <h:graphicImage url="../img/pdf.jpg"/>
                                        </a4j:commandLink>
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0 }" style="text-align:center">
                                        <rich:dropDownMenu>
                                            <f:facet name="label">
                                                <h:panelGroup>
                                                    <h:outputText value="Acciones"/>
                                                    <h:outputText styleClass="icon-menu3"/>
                                                </h:panelGroup>
                                            </f:facet>
                                            
                                            <rich:menuItem  submitMode="none" value="Duplicar información" 
                                                            rendered="#{ManagedComponentesProdVersion.controlPresentacionPrimaria 
                                                                            and data.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 2
                                                                            and data.forma.codForma ne 2
                                                                            and data.forma.codForma ne 25}" >
                                                <a4j:support event="onclick" reRender="formDuplicarInformacion"
                                                             oncomplete="Richfaces.showModalPanel('panelDuplicarInformacionProducto')" action="#{ManagedComponentesProdVersion.cargarDuplicarInformacionProducto_action}" >
                                                    <f:setPropertyActionListener target="#{ManagedComponentesProdVersion.componentesProdVersionDestinoInformacion}"
                                                                                                value="#{data}"/>
                                                </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuItem  submitMode="ajax" value="Modificar Fracciones"
                                                            oncomplete="redireccionar('modificarFraccionesProducto.jsf')"
                                                            rendered="#{ManagedComponentesProdVersion.controlPresentacionPrimaria 
                                                                            and data.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 2}" >
                                                <f:setPropertyActionListener target="#{ManagedComponentesProdVersion.componentesProdVersionModificarFracciones}"
                                                                             value="#{data}"/>
                                            </rich:menuItem>
                                            <rich:menuItem  rendered="#{(data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 33
                                                                            or data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 34) 
                                                                        and data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 1}"
                                                            submitMode="ajax"
                                                            oncomplete="redireccionar('editarComponentesProdVersion.jsf')">
                                                    <h:outputText value="Editar"/>
                                                    <f:setPropertyActionListener value="#{data}" target="#{ManagedComponentesProdVersion.componentesProdVersionEditar}"/>
                                            </rich:menuItem>
                                            <rich:menuItem  rendered="#{ ManagedComponentesProdVersion.permisoCreacionVersion
                                                                         and data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 1}"
                                                            submitMode="none" value="Eliminar">
                                                    <a4j:support event="onclick" oncomplete="if(#{ManagedComponentesProdVersion.mensaje eq '1'}){alert('Se elimino la versión');}else{alert('#{ManagedComponentesProdVersion.mensaje}')}"
                                                                 reRender="dataComponentesProdVersion"
                                                                 action="#{ManagedComponentesProdVersion.eliminarComponentesProdVersion_action(data.codVersion)}">
                                                        <f:setPropertyActionListener value="#{data}" target="#{ManagedComponentesProdVersion.componentesProdVersionEditar}"/>
                                                    </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuItem  rendered="#{data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 1}"
                                                            submitMode="none" value="Observaciones">
                                                <a4j:support event="onclick" 
                                                            oncomplete="Richfaces.showModalPanel('modalRegistrarObservacion')"
                                                            reRender="contenidoRegistrarObservacion"
                                                            action="#{ManagedComponentesProdVersion.seleccionarObservarVersion_action}">
                                                   <f:setPropertyActionListener value="#{data}" target="#{ManagedComponentesProdVersion.componentesProdVersionBean}"/>
                                                </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuItem  rendered="#{(ManagedComponentesProdVersion.controlControlCalidad 
                                                                                or ManagedComponentesProdVersion.controlEmpaqueSecundario 
                                                                                or ManagedComponentesProdVersion.controlPresentacionPrimaria 
                                                                                or ManagedComponentesProdVersion.controlRegistroSanitario)
                                                                        and ( data.estadosVersionComponentesProd.codEstadoVersionComponenteProd == 1
                                                                                || data.estadosVersionComponentesProd.codEstadoVersionComponenteProd==5)
                                                                        and data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 9}"
                                                            submitMode="none" value="Seleccion una acción" disabled="true">
                                            </rich:menuItem>
                                            <rich:menuSeparator/>
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
                                            <rich:menuItem  rendered="#{( data.estadosVersionComponentesProd.codEstadoVersionComponenteProd == 1
                                                                                or data.estadosVersionComponentesProd.codEstadoVersionComponenteProd==5)
                                                                        and data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 9}"
                                                            submitMode="none" value="Añadirme a Versión">
                                                    <a4j:support event="onclick" oncomplete="if(#{ManagedComponentesProdVersion.mensaje eq '1'}){alert('Se registro la transccion');}else{alert('#{ManagedComponentesProdVersion.mensaje}')}"
                                                                 reRender="dataComponentesProdVersion"
                                                                 action="#{ManagedComponentesProdVersion.agregarPersonalVersion_action}">
                                                        <f:setPropertyActionListener value="#{data}" target="#{ManagedComponentesProdVersion.componentesProdVersionBean}"/>
                                                    </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuItem  rendered="#{( data.estadosVersionComponentesProd.codEstadoVersionComponenteProd == 1
                                                                                or data.estadosVersionComponentesProd.codEstadoVersionComponenteProd==5)
                                                                        and data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 9}"
                                                            submitMode="none" value="Sin Necesidad de Cambios">
                                                    <a4j:support event="onclick" 
                                                                 oncomplete="if(#{ManagedComponentesProdVersion.mensaje eq '1'}){alert('Se registro la transaccion');}else{alert('#{ManagedComponentesProdVersion.mensaje}')}"
                                                                 reRender="dataComponentesProdVersion"
                                                                 action="#{ManagedComponentesProdVersion.sinNecesidadCambios_action}">
                                                        <f:setPropertyActionListener value="#{data}" target="#{ManagedComponentesProdVersion.componentesProdVersionBean}"/>
                                                    </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuSeparator/>
                                            <rich:menuItem  rendered="#{data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 1}"
                                                            submitMode="none" value="Enviar a Aprobación">
                                                    <a4j:support event="onclick" 
                                                                 oncomplete="if(#{ManagedComponentesProdVersion.mensaje eq '1'}){alert('Se envio la version a aprobación');/*registrarControlCambios();*/}else{alert('#{ManagedComponentesProdVersion.mensaje}')}"
                                                                 reRender="dataComponentesProdVersion"
                                                                 action="#{ManagedComponentesProdVersion.enviarAAprobacion_action}">
                                                        <f:setPropertyActionListener value="#{data}" target="#{ManagedComponentesProdVersion.componentesProdVersionBean}"/>
                                                    </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuSeparator rendered="#{data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 35}"/>
                                            <rich:menuItem value="Especificaciones de C.C." disabled="true"  rendered="#{ManagedComponentesProdVersion.controlControlCalidad}"/>
                                            <rich:menuItem  rendered="#{ data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 35
                                                                        and data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 1}"
                                                            icon="../img/EspecificacionesFisicas.png"
                                                            submitMode="none" value="Especificaciones Fisicas">
                                                    <a4j:support event="onclick" 
                                                                 oncomplete="redireccionar('especificacionesControlCalidad/especificacionesFisicas.jsf')"
                                                                 reRender="dataComponentesProdVersion"
                                                                 action="#{ManagedComponentesProdVersion.seleccionarComponenteProdVersion_action}">
                                                        <f:setPropertyActionListener value="#{data}" target="#{ManagedComponentesProdVersion.componentesProdVersionBean}"/>
                                                    </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuItem  rendered="#{ data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 35
                                                                        and data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 1}"
                                                            icon="../img/EspecificacionesQuimicas.png"
                                                            submitMode="none" value="Especificaciones Quimicas">
                                                    <a4j:support event="onclick" 
                                                                 oncomplete="redireccionar('especificacionesControlCalidad/especificacionesQuimicas.jsf')"
                                                                 reRender="dataComponentesProdVersion"
                                                                 action="#{ManagedComponentesProdVersion.seleccionarComponenteProdVersion_action}">
                                                        <f:setPropertyActionListener value="#{data}" target="#{ManagedComponentesProdVersion.componentesProdVersionBean}"/>
                                                    </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuItem  rendered="#{ data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 35
                                                                        and data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 1}"
                                                            icon="../img/EspecificacionesMicrobiologicas.png"
                                                            submitMode="none" value="Especificaciones Microbiologicas">
                                                    <a4j:support event="onclick" 
                                                                 oncomplete="redireccionar('especificacionesControlCalidad/especificacionesMicrobiologicas.jsf')"
                                                                 reRender="dataComponentesProdVersion"
                                                                 action="#{ManagedComponentesProdVersion.seleccionarComponenteProdVersion_action}">
                                                        <f:setPropertyActionListener value="#{data}" target="#{ManagedComponentesProdVersion.componentesProdVersionBean}"/>
                                                    </a4j:support>
                                            </rich:menuItem>
                                            <rich:menuSeparator rendered="#{data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 35}"/>
                                            <rich:menuItem value="Materiales" disabled="true" rendered="#{data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 35}"/>
                                            <rich:menuItem  rendered="#{ data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 35
                                                                        and data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 1}"
                                                            icon="../img/materialReactivo.png"
                                                            submitMode="none" value="Material Reactivo">
                                                    <a4j:support event="onclick" 
                                                                 oncomplete="redireccionar('../formullaMaestraVersiones/formulaMaestraDetalleMR/navegadorFormulaMaestraDetalleMRVersion.jsf')"
                                                                 reRender="dataComponentesProdVersion"
                                                                 action="#{ManagedComponentesProdVersion.seleccionarFormulaMaestraVersionProperty_action}">
                                                        <f:setPropertyActionListener value="#{data}" target="#{ManagedComponentesProdVersion.componentesProdVersionBean}"/>
                                                    </a4j:support>
                                            </rich:menuItem>
                                            
                                        </rich:dropDownMenu>
                                        <h:outputText value="Las transacciones de versionamiento para este producto estan deshabilitados por su estado" style="color:red"
                                                      rendered="#{data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 3 || 
                                                                  data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 5 ||
                                                                  data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq 7}"/>
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}" 
                                                 rendered="#{ManagedComponentesProdVersion.controlPresentacionPrimaria
                                                             and rowkey eq 0 }" style="text-align:center">
                                        <a4j:commandLink action="#{ManagedComponentesProdVersion.seleccionarFormulaMaestraVersion_action}" 
                                                         rendered="#{data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd == 1
                                                                and data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 34}"
                                                oncomplete="window.location.href='../formullaMaestraVersiones/formulaMaestraDetalleMP/navegadorFormulaMaestraVersionMP.jsf?data='+(new Date()).getTime().toString();">
                                                    <h:graphicImage url="../img/MateriaPrima.png" alt="Materia Prima"/>
                                        </a4j:commandLink>
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"
                                                 rendered="#{ManagedComponentesProdVersion.controlPresentacionPrimaria
                                                             and rowkey eq 0 }" style="text-align:center">
                                        <a4j:commandLink action="#{ManagedComponentesProdVersion.seleccionarFormulaMaestraVersion_action}"
                                                         rendered="#{data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd == 1
                                                                        and data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 34}"
                                                        oncomplete="window.location.href='../formullaMaestraVersiones/formulaMaestraDetalleEP/navegadorFormulaMaestraEP.jsf?data='+(new Date()).getTime().toString();">
                                            <h:graphicImage url="../img/EmpPrim.png" alt="Empaque Primario"/>
                                        </a4j:commandLink>
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0 }" style="text-align:center">
                                        <a4j:commandLink action="#{ManagedComponentesProdVersion.seleccionarComponentesProdVersionEs_action}"  
                                                        oncomplete="window.location.href='../formullaMaestraVersiones/formulaMaestraDetalleES/navegadorFormulaMaestraEsVersion.jsf?data='+(new Date()).getTime().toString();">
                                            <h:graphicImage url="../img/EmpSec.png" alt="Empaque Secundario"/>
                                        </a4j:commandLink>
                                    </rich:column>
                                    
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{ManagedComponentesProdVersion.controlPresentacionPrimaria && rowkey eq 0}" style="text-align:center">
                                        <a4j:commandLink action="#{ManagedComponentesProdVersion.seleccionarMostrarProcesosOrdenManufactura}"
                                                         rendered="#{!ManagedComponentesProdVersion.componentesProdBean.informacionCompleta
                                                                    or (data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd == 1
                                                                        and data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 34)}"
                                                         oncomplete="javascript:Richfaces.showModalPanel('modalDefinirProcesos');" reRender="contenidoDefinirProcesos">
                                            <h:graphicImage url="../img/pasos.jpg" alt="Procesos de Producción"/>
                                        </a4j:commandLink>
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{ManagedComponentesProdVersion.controlPresentacionPrimaria && rowkey eq 0}" style="text-align:center">
                                        <rich:dropDownMenu style="padding:0px !important"
                                                           rendered="#{!ManagedComponentesProdVersion.componentesProdBean.informacionCompleta
                                                                    or (data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd == 1
                                                                        and data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 34)}">
                                            <f:facet name="label">
                                                <h:panelGroup>
                                                    <h:graphicImage alt="Limpieza" url="../img/limpiezaGeneral.jpg"/>
                                                </h:panelGroup>
                                            </f:facet>
                                            
                                            <rich:menuItem  action="#{ManagedComponentesProdVersion.seleccionarComponenteProdVersionProcesosPreparado_action}"
                                                            submitMode="ajax" 
                                                            oncomplete="window.location.href='limpiezaSecciones/navegadorLimpiezaSecciones.jsf?data='+(new Date()).getTime().toString();">
                                                    <h:outputText value="Limpieza Secciones(Producción)"/>
                                            </rich:menuItem>
                                            <rich:separator/>
                                            <rich:menuItem action="#{ManagedComponentesProdVersion.seleccionarComponenteProdVersionProcesosPreparado_action}"
                                                            submitMode="ajax" 
                                                            oncomplete="window.location.href='limpiezaMaquinarias/navegadorLimpiezaMaquinaria.jsf?data='+(new Date()).getTime().toString();">
                                                    <h:outputText value="Limpieza Maquinarias"/>
                                            </rich:menuItem>
                                            <rich:menuItem  action="#{ManagedComponentesProdVersion.seleccionarComponenteProdVersionProcesosPreparado_action}"
                                                            submitMode="ajax" 
                                                            oncomplete="window.location.href='limpiezaPesaje/navegadorLimpiezaPesaje.jsf?data='+(new Date()).getTime().toString();">
                                                    <h:outputText value="Limpieza Area Pesaje"/>
                                            </rich:menuItem>
                                            <rich:menuItem  action="#{ManagedComponentesProdVersion.seleccionarComponenteProdVersionProcesosPreparado_action}"
                                                            submitMode="ajax"
                                                            oncomplete="window.location.href='limpiezaPesaje/navegadorLimpiezaUtensiliosPesaje.jsf?data='+(new Date()).getTime().toString();">
                                                    <h:outputText value="Limpieza Utensilios Pesaje"/>
                                            </rich:menuItem>
                                            
                                        </rich:dropDownMenu>
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{ManagedComponentesProdVersion.controlPresentacionPrimaria && rowkey eq 0}" style="text-align:center">
                                        <a4j:commandLink action="#{ManagedComponentesProdVersion.seleccionarComponenteProdVersionProcesosPreparado_action}"
                                                         rendered="#{!ManagedComponentesProdVersion.componentesProdBean.informacionCompleta
                                                                    or (data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd == 1
                                                                        and data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 34)}"
                                                        oncomplete="window.location.href='procesosPreparadoProducto/navegadorProcesosPreparadoProducto.jsf?data='+(new Date()).getTime().toString();">
                                            <h:graphicImage url="../img/flujoPreparado.jpg" alt="Flujo de preparado"/>
                                            <f:setPropertyActionListener value="#{data}" target="#{ManagedComponentesProdVersion.componentesProdVersionBean}"/>
                                        </a4j:commandLink>
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{ManagedComponentesProdVersion.controlPresentacionPrimaria && rowkey eq 0}" style="text-align:center">
                                        <a4j:commandLink action="#{ManagedComponentesProdVersion.seleccionarComponenteProdVersionProcesosPreparado_action}"
                                                         rendered="#{!ManagedComponentesProdVersion.componentesProdBean.informacionCompleta
                                                                    or (data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd == 1
                                                                        and data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 34)}"
                                                        oncomplete="redireccionar('filtrosProduccionProducto/navegadorFiltrosProduccionProducto.jsf')">
                                            <h:graphicImage url="../img/filtroProduccion.jpg" alt="Filtros de Producción"/>
                                            <f:setPropertyActionListener value="#{data}" target="#{ManagedComponentesProdVersion.componentesProdVersionBean}"/>
                                        </a4j:commandLink>
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{ManagedComponentesProdVersion.controlPresentacionPrimaria && rowkey eq 0}" style="text-align:center">
                                        <a4j:commandLink action="#{ManagedComponentesProdVersion.seleccionarComponenteProdVersion_action}"
                                                        rendered="#{!ManagedComponentesProdVersion.componentesProdBean.informacionCompleta
                                                                    or (data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd == 1
                                                                        and data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 34)}"
                                                        oncomplete="redireccionar('maquinariasPorProceso/navegadorMaquinariasPorProceso.jsf')">
                                            <h:graphicImage url="../img/maquinaria.jpg" alt="Maquinarias Por Proceso"/>
                                            <f:setPropertyActionListener value="#{data}" target="#{ManagedComponentesProdVersion.componentesProdVersionBean}"/>
                                        </a4j:commandLink>
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{ManagedComponentesProdVersion.controlPresentacionPrimaria && rowkey eq 0}" style="text-align:center">
                                        <a4j:commandLink action="#{ManagedComponentesProdVersion.seleccionarComponenteProdVersion_action}"
                                                         rendered="#{!ManagedComponentesProdVersion.componentesProdBean.informacionCompleta
                                                                    or (data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd == 1
                                                                        and data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 34)}"
                                                        oncomplete="redireccionar('especificacionesProcesos/navegadorEspecificacionesProcesos.jsf')">
                                            <h:graphicImage url="../img/granulado.jpg" alt="Especificaciones De Granulado"/>
                                            <f:setPropertyActionListener value="#{data}" target="#{ManagedComponentesProdVersion.componentesProdVersionBean}"/>
                                        </a4j:commandLink>
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{ManagedComponentesProdVersion.controlPresentacionPrimaria && rowkey eq 0}" style="text-align:center">
                                        <a4j:commandLink action="#{ManagedComponentesProdVersion.seleccionarComponenteProdVersion_action}"
                                                         rendered="#{!ManagedComponentesProdVersion.componentesProdBean.informacionCompleta
                                                                    or (data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd == 1
                                                                        and data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 34)}"
                                                        oncomplete="redireccionar('indicacionesProceso/navegadorIndicacionesProceso.jsf')">
                                            <h:graphicImage url="../img/indicaciones.jpg" alt="Especificaciones De Granulado"/>
                                            <f:setPropertyActionListener value="#{data}" target="#{ManagedComponentesProdVersion.componentesProdVersionBean}"/>
                                        </a4j:commandLink>
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{ManagedComponentesProdVersion.controlPresentacionPrimaria && rowkey eq 0}" style="text-align:center">
                                        <a4j:commandLink action="#{ManagedComponentesProdVersion.seleccionarComponenteProdVersion_action}"
                                                         rendered="#{!ManagedComponentesProdVersion.componentesProdBean.informacionCompleta
                                                                    or (data.componentesProdVersionModificacionPersonal.estadosVersionComponentesProd.codEstadoVersionComponenteProd == 1
                                                                        and data.componentesProdVersionModificacionPersonal.tiposPermisosEspecialesAtlas.codTipoPermisoEspecialAtlas eq 34)}"
                                                        oncomplete="redireccionar('documentacionAplicada/navegadorDocumentacionAplicada.jsf')">
                                            <h:graphicImage url="../img/documentacionAplicada.jpg" alt="Documentación Aplicada"/>
                                            <f:setPropertyActionListener value="#{data}" target="#{ManagedComponentesProdVersion.componentesProdVersionBean}"/>
                                        </a4j:commandLink>
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{ManagedComponentesProdVersion.controlPresentacionPrimaria && rowkey eq 0}" style="text-align:center">
                                        <a4j:commandLink action="#{ManagedComponentesProdVersion.mostrarOrdenManufacturaVersionProducto_action}" oncomplete="openPopup('../programaProduccion/impresionOrdenManufactura.jsf?codLote=H#{data.codVersion}&codProgramaProd=0&data='+(new Date()).getTime().toString());" >
                                            <h:graphicImage url="../img/OM.jpg"  alt="Orden de Manufactura" />
                                            <f:setPropertyActionListener value="#{data}" target="#{ManagedComponentesProdVersion.componentesProdVersionBean}"/>
                                        </a4j:commandLink>
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{ManagedComponentesProdVersion.controlPresentacionPrimaria && rowkey eq 0}" style="text-align:center">
                                        <a4j:commandLink action="#{ManagedComponentesProdVersion.mostrarOrdenManufacturaVersionProducto_action}" oncomplete="openPopup('reporteEtiquetas.jsp?codLoteProduccion=H#{data.codVersion}&data='+(new Date()).getTime().toString());" >
                                            <h:graphicImage url="../img/etiqueta.gif"  alt="Etiquetas" />
                                        </a4j:commandLink>
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}" style="text-align:center">
                                        <a4j:commandLink oncomplete="verReporteComponentesProdVersion('#{ManagedComponentesProdVersion.componentesProdBean.codCompprod}','#{data.codVersion}');">
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
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="#{data.fechaInicioVigencia}" >
                                            <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                                        </h:outputText>
                                    </rich:column>
                                    <rich:column>
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
                                        <h:outputText value="#{subData.fechaAsignacion}">
                                            <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                                        </h:outputText>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{subData.fechaInclusionVersion}">
                                            <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                                        </h:outputText>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{subData.fechaEnvioAprobacion}">
                                            <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                                        </h:outputText>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="#{subData.fechaDevolucionVersion}">
                                            <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                                        </h:outputText>
                                    </rich:column>
                                </rich:columnGroup>
                            </rich:subTable>
                    </rich:dataTable>
                    <br>
                    

                    
                    
                    

                    
                    
                    <div id="bottonesAcccion" class="barraBotones">
                        <a4j:commandButton styleClass="btn" oncomplete="redireccionar('navegadorComponentesProd.jsf')"
                                           value="Volver"/>
                    </div>
                    
                </div>
               
            </a4j:form>
            
            <rich:modalPanel id="modalRegistrarObservacion" minHeight="200" headerClass="headerClassACliente"
                                     minWidth="550" height="200" width="700" zindex="100" >
                    <f:facet name="header">
                        <h:outputText value="<center>Registrar Observación</center>" escape="false"/>
                    </f:facet>
                    <a4j:form>
                        <center>
                            <h:panelGroup id="contenidoRegistrarObservacion">
                                <h:panelGrid columns="3" style="width:100%">
                                    <h:outputText value="Producto" styleClass="outputTextBold"/>
                                    <h:outputText value="::" styleClass="outputTextBold"/>
                                    <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.nombreProdSemiterminado}" styleClass="outputText2"/>
                                    <h:outputText value="Nro Versión" styleClass="outputTextBold"/>
                                    <h:outputText value="::" styleClass="outputTextBold"/>
                                    <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.nroVersion}" styleClass="outputText2"/>
                                    <h:outputText value="Observación" styleClass="outputTextBold"/>
                                    <h:outputText value="::" styleClass="outputTextBold"/>
                                    <h:inputTextarea style="width:100%" value="#{ManagedComponentesProdVersion.componentesProdVersionModificacionObservar.observacionPersonalVersion}" styleClass="inputText" rows="4"/>
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
            <rich:modalPanel id="modalPanelSubirArchivo" minHeight="350" headerClass="headerClassACliente"
                                     minWidth="550" height="350" width="700" zindex="100" >
                    <f:facet name="header">
                        <h:outputText value="Subir Certificado de marca"/>
                    </f:facet>
                        <div align="center"  >
                            <iframe src="" id="frameSubir" width="100%" height="300" align="center"></iframe>
                        </div>

            </rich:modalPanel>
            <a4j:include viewId="panelCrearVersion.jsp" id="panelCrearVersion"/>
            <a4j:include viewId="duplicarInformacionComponentesProdVersion.jsp" id="duplicarInformacion"/>
            <a4j:include viewId="panelProcesosOrdenManufactura.jsp" id="panelProcesosOrdenManufactura"/>
            <a4j:include viewId="panelVersionModificacion.jsp" id="panelVersionModificacion"/>
            <a4j:include viewId="/message.jsp"/>
            <a4j:include viewId="/panelProgreso.jsp"/>
    </html>
    
</f:view>

