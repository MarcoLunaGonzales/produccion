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
                .subCabecera
                {
                    background-color:#9d5a9e;
                    color:white;
                    font-weight:bold;
                }
                .headerLocal{
                    background-image:none;
                    background-color:#9d5f9f;
                    font-weight:bold;
                }
                .celdaVersion{
                    background-color:#eeeeee;
                }
            </style>
            <script>
                var seleccionado=0;
                function alMenosUno(nombreTabla)
                {
                    var tabla=document.getElementById(nombreTabla);
                    var contador=0;
                    for(var i=1;i<tabla.rows.length;i++)
                    {
                        if((tabla.rows[i].cells[0].getElementsByTagName('input').length>0)&&
                            (tabla.rows[i].cells[0].getElementsByTagName('input')[0].checked))
                        {
                            seleccionado=tabla.rows[i].cells[1].getElementsByTagName('input')[0].value;
                            contador++;
                        }
                    }
                    if(contador==0)
                    {
                        alert('Debe seleccionar al menos un registro');
                        return false;
                    }
                    if(contador>1)
                    {
                        alert('No puede seleccionar mas de un registro');
                        return false;
                    }
                    return true;
                }
                function verReporteFormulaVersion(codVersionFm,codFormulaMaestra)
                {
                    var url="reporteFormulaMaestraVersion.jsf?codversion="+codVersionFm+"&codFormulaMaestra="+codFormulaMaestra+"&data="+(new Date()).getTime().toString();
                    openPopup(url);
                }
                function openPopup(url){
                       window.open(url,'detalle'+Math.round((Math.random()*1000)),'top=50,left=200,width=800,height=600,scrollbars=1,resizable=1');
                }
                function registrarControlDeCambios(codFormulaMaestraVersion,codCompProdVersion)
                {
                    urlOOS="../controlDeCambios/registroControlCambios.jsf?codFormulaMaestraVersion="+codFormulaMaestraVersion+
                        "&codCompProdVersion="+codCompProdVersion+"&date="+(new Date()).getTime().toString()+"&ale="+Math.random();
                    window.open(urlOOS,'detalle'+Math.round((Math.random()*1000)),'top=50,left=200,width=800,height=600,scrollbars=1,resizable=1');

                }
                function registrarControlCambios()
                {
                    registrarControlDeCambios(seleccionado,0);
                }
                function verificarTransaccionUsuario(codPersonal,celda)
                {
                    var contIndex=parseInt(celda.parentNode.parentNode.rowIndex-1);
                    var permiso=false;
                    if(parseInt(celda.parentNode.parentNode.cells[11].getElementsByTagName("input")[0].value)==2||
                       parseInt(celda.parentNode.parentNode.cells[11].getElementsByTagName("input")[0].value)==4)
                    {
                        permiso=true;
                    }
                    if(parseInt(celda.parentNode.parentNode.cells[9].getElementsByTagName("input")[0].value)==codPersonal)
                    {
                        permiso=true;
                    }
                    while((!permiso)&&celda.parentNode.parentNode.parentNode.rows[contIndex]!=null&&celda.parentNode.parentNode.parentNode.rows[contIndex].cells.length==2)
                    {
                        if(parseInt(celda.parentNode.parentNode.parentNode.rows[contIndex].cells[0].getElementsByTagName("input")[0].value)==codPersonal)
                        {
                            permiso=true;
                        }
                        contIndex++;
                    }
                    if(!permiso)alert('No se encuentra registrada como personal para modificar la version');
                    return permiso;
                }
    </script>
        </head>
        <body>
            <h:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedVersionesFormulaMaestra.cargarVersionesFormulaMaestra}"   />
                    <h:outputText styleClass="outputTextTitulo"  value="Listado de Versiones de Formula Maestra" style="font-size:1.2em !important" />
                    <rich:panel headerClass="headerLocal" style="width:50%;margin-top:0.3em">
                        <f:facet name="header">
                            <h:outputText value="Datos Del Producto"/>
                        </f:facet>
                        <h:panelGrid columns="3" style="width:auto">
                            <h:outputText value="Producto" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraBean.componentesProd.nombreProdSemiterminado}" styleClass="outputText2" />
                            <h:outputText value="Tipo Produccion" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraBean.componentesProd.tipoProduccion.nombreTipoProduccion}" styleClass="outputText2" />
                        </h:panelGrid>
                    </rich:panel>
                        <rich:dataTable value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionesList}"
                                    var="data" id="dataFormula"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                                    headerClass="headerLocal"  style="margin-top:8px;"
                                    binding="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionesData}">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column rowspan="2">
                                    <h:outputText value=""  />
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Nro Version"  />
                                </rich:column>
                                <rich:column rowspan="2">
                                   <h:outputText value="Personal Creacion"  />
                                </rich:column>
                                <rich:column colspan="3">
                                   <h:outputText value="Tipo Modificacion"  />
                                </rich:column>
                                <rich:column rowspan="2">
                                   <h:outputText value="Cantidad Lote"  />
                                </rich:column>
                                <rich:column rowspan="2">
                                   <h:outputText value="Fecha Creacion"  />
                                </rich:column>
                                <rich:column rowspan="2">
                                   <h:outputText value="Fecha Inicio Vigencia"  />
                                </rich:column>
                                <rich:column rowspan="2">
                                   <h:outputText value="Personal Modificación"  />
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Estado<br>Personal" escape="false"  />
                                </rich:column>
                                <rich:column rowspan="2">
                                   <h:outputText value="Estado Version"  />
                                </rich:column>
                                <rich:column rowspan="2" rendered="#{ManagedVersionesFormulaMaestra.codAreaEmpresaPersonal eq '41' || ManagedVersionesFormulaMaestra.codAreaEmpresaPersonal eq '77'}">
                                    <h:outputText value="MP"  />
                                </rich:column>
                                <rich:column rowspan="2" rendered="#{ManagedVersionesFormulaMaestra.codAreaEmpresaPersonal eq '41' || ManagedVersionesFormulaMaestra.codAreaEmpresaPersonal eq '77'}">
                                        <h:outputText value="EP"  />
                                </rich:column>
                                <rich:column rowspan="2" rendered="#{ManagedVersionesFormulaMaestra.codAreaEmpresaPersonal eq '85' || ManagedVersionesFormulaMaestra.codAreaEmpresaPersonal eq '93' }">
                                    <h:outputText value="ES"  />
                                </rich:column>
                                <rich:column rowspan="2" rendered="#{ManagedVersionesFormulaMaestra.codAreaEmpresaPersonal eq '40'}">
                                    <h:outputText value="MR"  />
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Reporte<br>Version" escape="false"  />
                                </rich:column>
                                <rich:column breakBefore="true">
                                    <h:outputText value="MP y EP"  />
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="ES"  />
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="R"  />
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        <rich:subTable var="subData" value="#{data.formulaMaestraVersionModificacionList}" rowKeyVar="rowkey">
                                <rich:column   rowspan="#{data.formulaMaestraVersionModificacionLength}"  rendered="#{rowkey eq 0}" >
                                    <h:selectBooleanCheckbox value="#{data.checked}"  rendered="#{data.estadoVersionFormulaMaestra.codEstadoVersionFormulaMaestra eq '1' || data.estadoVersionFormulaMaestra.codEstadoVersionFormulaMaestra eq '5'}" />
                                </rich:column>
                                <rich:column  rowspan="#{data.formulaMaestraVersionModificacionLength}"  rendered="#{rowkey eq 0}">
                                    <h:outputText value="#{data.nroVersion}"  title="Cantidad Lote" />
                                    <h:inputHidden value="#{data.codVersion}"/>
                                </rich:column>
                                <rich:column  rowspan="#{data.formulaMaestraVersionModificacionLength}"  rendered="#{rowkey eq 0}">
                                    <h:outputText value="#{data.personalCreacion.nombrePersonal}" title="Personal Creacion" />
                                </rich:column>
                                <rich:column  rowspan="#{data.formulaMaestraVersionModificacionLength}"  rendered="#{rowkey eq 0}">
                                    <h:outputText value="X" rendered="#{data.modificacionMPEP}" />
                                </rich:column>
                                <rich:column  rowspan="#{data.formulaMaestraVersionModificacionLength}"  rendered="#{rowkey eq 0}">
                                    <h:outputText value="X" rendered="#{data.modificacionES}" />
                                </rich:column>
                                <rich:column  rowspan="#{data.formulaMaestraVersionModificacionLength}"  rendered="#{rowkey eq 0}">
                                    <h:outputText value="X" rendered="#{data.modificacionR}" />
                                </rich:column>
                                <rich:column  rowspan="#{data.formulaMaestraVersionModificacionLength}"  rendered="#{rowkey eq 0}">
                                    <h:outputText value="#{data.cantidadLote}"  title="Cantidad Lote" />
                                </rich:column>
                                <rich:column  rowspan="#{data.formulaMaestraVersionModificacionLength}"  rendered="#{rowkey eq 0}">
                                    <h:outputText value="#{data.fechaModificacion}"  title="Fecha Creacion">
                                        <f:convertDateTime pattern="dd/MM/yyyy HH:mm" />
                                    </h:outputText>
                                </rich:column>
                                <rich:column  rowspan="#{data.formulaMaestraVersionModificacionLength}"  rendered="#{rowkey eq 0}">
                                    <h:outputText value="#{data.fechaInicioVigencia}"  title="Fecha Inicio Vigencia" rendered="#{data.fechaInicioVigencia !=null}">
                                        <f:convertDateTime pattern="dd/MM/yyyy HH:mm" />
                                    </h:outputText>
                                </rich:column>
                                <rich:column styleClass="celdaVersion">
                                        <h:outputText value="#{subData.personal.nombrePersonal}"/>
                                        <h:inputHidden value="#{subData.personal.codPersonal}"/>
                               </rich:column >
                               <rich:column styleClass="celdaVersion">
                                     <h:outputText value="#{subData.estadosVersionFormulaMaestra.nombreEstadoVersionFormulaMaestra}"/>
                               </rich:column >
                                <rich:column  rowspan="#{data.formulaMaestraVersionModificacionLength}"  rendered="#{rowkey eq 0}">
                                    <h:outputText value="#{data.estadoVersionFormulaMaestra.nombreEstadoVersionFormulaMaestra}" />
                                    <h:inputHidden value="#{data.estadoVersionFormulaMaestra.codEstadoVersionFormulaMaestra}"/>
                                </rich:column>
                                 
                                <rich:column rendered="#{(ManagedVersionesFormulaMaestra.codAreaEmpresaPersonal eq '41' || ManagedVersionesFormulaMaestra.codAreaEmpresaPersonal eq '77')&&(rowkey eq 0)}"
                                rowspan="#{data.formulaMaestraVersionModificacionLength}" >
                                    <a4j:commandLink onclick="if(!verificarTransaccionUsuario(#{ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal},this)){return false;}"
                                    action="#{ManagedVersionesFormulaMaestra.seleccionarFormulaMaestraVersion}"
                                    oncomplete="var a=Math.random();window.location.href='formulaMaestraDetalleMP/navegadorFormulaMaestraVersionMP.jsf?a='+a;"
                                    rendered="#{data.estadoVersionFormulaMaestra.codEstadoVersionFormulaMaestra eq '1' || data.estadoVersionFormulaMaestra.codEstadoVersionFormulaMaestra eq '5'}">
                                        <h:graphicImage url="../img/organigrama3.jpg" />
                                    </a4j:commandLink>
                                </rich:column>
                                <rich:column rendered="#{(ManagedVersionesFormulaMaestra.codAreaEmpresaPersonal eq '41' || ManagedVersionesFormulaMaestra.codAreaEmpresaPersonal eq '77')&&(rowkey eq 0)}"
                                rowspan="#{data.formulaMaestraVersionModificacionLength}" >
                                    <a4j:commandLink onclick="if(!verificarTransaccionUsuario(#{ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal},this)){return false;}"
                                    action="#{ManagedVersionesFormulaMaestra.seleccionarFormulaMaestraVersion}"
                                    oncomplete="var a=Math.random();window.location.href='formulaMaestraDetalleEP/navegadorFormulaMaestraEP.jsf?a='+a;">
                                        <h:graphicImage url="../img/organigrama3.jpg" />
                                    </a4j:commandLink>
                                </rich:column>
                                <rich:column rendered="#{(ManagedVersionesFormulaMaestra.codAreaEmpresaPersonal eq '85' || ManagedVersionesFormulaMaestra.codAreaEmpresaPersonal eq '93')&&(rowkey eq 0)}"
                                    rowspan="#{data.formulaMaestraVersionModificacionLength}" >
                                    <a4j:commandLink onclick="if(!verificarTransaccionUsuario(#{ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal},this)){return false;}"
                                    action="#{ManagedVersionesFormulaMaestra.seleccionarFormulaMaestraVersion}"
                                    oncomplete="var a=Math.random();window.location.href='formulaMaestraDetalleES/navegadorFormulaMaestraEs.jsf?a='+a;"
                                    rendered="#{data.estadoVersionFormulaMaestra.codEstadoVersionFormulaMaestra eq '1' || data.estadoVersionFormulaMaestra.codEstadoVersionFormulaMaestra eq '5'}">
                                        <h:graphicImage url="../img/organigrama3.jpg" />
                                    </a4j:commandLink>
                                </rich:column>
                                <rich:column rendered="#{(ManagedVersionesFormulaMaestra.codAreaEmpresaPersonal eq '40')&&(rowkey eq 0)}"
                                    rowspan="#{data.formulaMaestraVersionModificacionLength}" >
                                    <a4j:commandLink onclick="if(!verificarTransaccionUsuario(#{ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal},this)){return false;}"
                                    action="#{ManagedVersionesFormulaMaestra.seleccionarFormulaMaestraVersion}"
                                    oncomplete="var a=Math.random();window.location.href='formulaMaestraDetalleMR/navegadorFormulaMaestraDetalleMRVersion.jsf?l='+a;"
                                    rendered="#{data.estadoVersionFormulaMaestra.codEstadoVersionFormulaMaestra eq '1' || data.estadoVersionFormulaMaestra.codEstadoVersionFormulaMaestra eq '5'}">
                                        <h:graphicImage url="../img/organigrama3.jpg" />
                                    </a4j:commandLink>
                                </rich:column>
                                <rich:column rowspan="#{data.formulaMaestraVersionModificacionLength}" rendered="#{(rowkey eq 0)}">
                                     <a4j:commandLink oncomplete="verReporteFormulaVersion('#{data.codVersion}','#{ManagedVersionesFormulaMaestra.formulaMaestraBean.codFormulaMaestra}');" >
                                        <h:graphicImage url="../img/organigrama3.jpg" />
                                    </a4j:commandLink>
                                </rich:column>
                        </rich:subTable>
                    </rich:dataTable>
                <div align="center" style="margin-top:12px">
                    <a4j:commandButton value="Agregar Version"
                    action="#{ManagedVersionesFormulaMaestra.crearNuevaVersionFormulaMaestra_action}" styleClass="btn" oncomplete="if(#{ManagedVersionesFormulaMaestra.mensaje eq '1'}){alert('Se creo la nueva version');}else{alert('#{ManagedVersionesFormulaMaestra.mensaje}')}"
                    reRender="dataFormula"/>
                    <a4j:commandButton value="Editar" onclick="if(!alMenosUno('form1:dataFormula')){return false;}" action="#{ManagedVersionesFormulaMaestra.editarFormulaMaestraDuplicada_action}" oncomplete="var a=Math.random();window.location.href='editarNuevaFormulaMaestra.jsf?nue='+a"
                    styleClass="btn" rendered="#{(ManagedVersionesFormulaMaestra.codAreaEmpresaPersonal eq '41' || ManagedVersionesFormulaMaestra.codAreaEmpresaPersonal eq '77')}"/>
                    <a4j:commandButton value="Eliminar" onclick="if(!alMenosUno('form1:dataFormula')){return false;}" action="#{ManagedVersionesFormulaMaestra.eliminarVersionFormulaMaestra_action}" oncomplete="if(#{ManagedVersionesFormulaMaestra.mensaje eq '1'}){alert('Se elimino la version');}else{alert('#{ManagedVersionesFormulaMaestra.mensaje}');}"
                    styleClass="btn" reRender="dataFormula"/>
                    <a4j:commandButton value="Enviar a Aprobacion" onclick="if(confirm('Esta seguro de enviar la version a aprobación?')){if(!alMenosUno('form1:dataFormula')){return false;}}"
                    action="#{ManagedVersionesFormulaMaestra.enviarVersionAAprobacion_action}" styleClass="btn" oncomplete="if(#{ManagedVersionesFormulaMaestra.mensaje eq '1'}){alert('Se envio la version a Aprobacion');registrarControlCambios();}else{aler('#{ManagedVersionesFormulaMaestra.mensaje}')}"
                    reRender="dataFormula"/>
                    <a4j:commandButton value="Añadirme a Version" onclick="if(!alMenosUno('form1:dataFormula')){return false;}" 
                    action="#{ManagedVersionesFormulaMaestra.adjuntarPersonalModificacion}" styleClass="btn" oncomplete="if(#{ManagedVersionesFormulaMaestra.mensaje eq '1'}){alert('Se registro como personal para modificar');}else{alert('#{ManagedVersionesFormulaMaestra.mensaje}');}"
                    reRender="dataFormula"/>
                    <a4j:commandButton value="Cancelar" oncomplete="var a=Math.random();window.location.href='../formula_maestra/navegadorFormulaMaestraProduccion.jsf?nue='+a"
                    styleClass="btn"/>
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

