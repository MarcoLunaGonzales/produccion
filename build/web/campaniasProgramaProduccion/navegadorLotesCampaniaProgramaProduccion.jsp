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
            <style  type="text/css">
                .seleccionado
                {
                    background-color:#90EE90;
                }
            </style>
            <script  type="text/javascript">
                function openPopup(url){
                       window.open(url,'detalle'+Math.round((Math.random()*1000)),'top=50,left=200,width=800,height=600,scrollbars=1,resizable=1');
                }
                function verFormatoImpresionOOS(codRegistroOOS)
                {
                    urlOOS="reporteOOSControlCalidad.jsf?codRegistroOOS="+codRegistroOOS+"&date="+(new Date()).getTime().toString()+"&ale="+Math.random();
                    window.open(urlOOS,'detalle'+Math.round((Math.random()*1000)),'top=50,left=200,width=800,height=600,scrollbars=1,resizable=1');
                    
                }
                A4J.AJAX.onError = function(req,status,message){
                window.alert("Ocurrio un error "+message+" continue con su transaccion ");
                }
                A4J.AJAX.onExpired = function(loc,expiredMsg){
                if(window.confirm("Ocurrio un error al momento realizar la transaccion: "+expiredMsg+" location: "+loc)){
                return loc;
                } else {
                return false;
                }
                }

                function editarCampania(nametable){
                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=2;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    if(cel.getElementsByTagName('input').length>0)
                    {
                        if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                              if(cel.getElementsByTagName('input')[0].checked){
                               count++;
                             }

                         }
                    }

                   }
                   if(count==1){
                      return true;
                   } else if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                   }
                   else if(count>1){
                       alert('Solo puede escoger un registro');
                       return false;
                   }
                }
         </script>
        </head>
             <a4j:form id="form1">
                <div align="center">
                    
                    <h:outputText value="#{ManagedCampanasProgramaProduccion.cargarCampaniasProgramaProduccion}"  />
                    <h:outputText styleClass="outputTextTitulo"  value="Programas de Producción" />
                    <rich:panel headerClass="headerClassACliente" style="width:70%">
                        <f:facet name="header">
                            <h:outputText value="Datos Programa Produccion"/>
                        </f:facet>
                        <h:panelGrid columns="3">
                            <h:outputText value="Programa Produccion" styleClass="outputText2" style="font-weigth:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weigth:bold"/>
                            <h:outputText value="#{ManagedCampanasProgramaProduccion.programaProduccionPeriodoBean.nombreProgramaProduccion}" styleClass="outputText2"/>
                            <h:outputText value="Observación" styleClass="outputText2" style="font-weigth:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weigth:bold"/>
                            <h:outputText value="#{ManagedCampanasProgramaProduccion.programaProduccionPeriodoBean.obsProgramaProduccion}" styleClass="outputText2"/>
                        </h:panelGrid>
                    </rich:panel>
                        <rich:dataTable value="#{ManagedCampanasProgramaProduccion.campaniaProgramaProduccionList}"
                                    style="margin-top:12px;" var="data" id="dataProgramaPeriodo"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" >
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column rowspan="2">
                                    <h:outputText value=""  />
                                </rich:column >
                                 <rich:column rowspan="2">
                                    <h:outputText value="Nombre Campaña"  />
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Tipo Campaña"  />
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Producto Campaña"  />
                                </rich:column>
                                <rich:column colspan="4">
                                    <h:outputText value="Lotes Campaña"  />
                                </rich:column>
                                <rich:column  breakBefore="true">
                                    <h:outputText value="Lote"  />
                                </rich:column>
                                <rich:column  >
                                        <h:outputText value="Producto"  />
                                </rich:column>
                                <rich:column  >
                                    <h:outputText value="Tipo Produccion"  />
                                </rich:column>
                                <rich:column  >
                                    <h:outputText value="Tam. Lote"  />
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        <rich:subTable var="subData" value="#{data.campaniaProgramaProduccionDetalleList}" rowKeyVar="rowkey">
                            <rich:column rowspan="#{data.campaniaProgramaProduccionDetalleListLength}"  rendered="#{rowkey eq 0}">
                                <h:selectBooleanCheckbox value="#{data.checked}"/>
                            </rich:column>

                            <rich:column rowspan="#{data.campaniaProgramaProduccionDetalleListLength}"  rendered="#{rowkey eq 0}">
                                <h:outputText value="#{data.nombreCampaniaProgramaProduccion}"  />
                            </rich:column>
                            <rich:column rowspan="#{data.campaniaProgramaProduccionDetalleListLength}"  rendered="#{rowkey eq 0}">
                                <h:outputText value="#{data.tiposCampaniaProgramaProduccion.nombreTipoCampaniaProgramaProduccion}"  />
                            </rich:column>
                            <rich:column rowspan="#{data.campaniaProgramaProduccionDetalleListLength}"  rendered="#{rowkey eq 0}">
                                <h:outputText value="#{data.componentesProd.nombreProdSemiterminado}"  />
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{subData.programaProduccion.codLoteProduccion}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{subData.programaProduccion.componentesProdVersion.nombreProdSemiterminado}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{subData.programaProduccion.tiposProgramaProduccion.nombreTipoProgramaProd}"/>
                            </rich:column>
                            <rich:column>
                                <h:outputText value="#{subData.programaProduccion.cantidadLote}"/>
                            </rich:column>
                        </rich:subTable>
                        
                    </rich:dataTable>
                    <div style="margin-top:1em">
                    <a4j:commandButton value="Agregar" styleClass="btn" oncomplete="window.location.href='agregarCampaniaProgramaProduccion.jsf?data='+(new Date()).getTime().toString()"
                    />
                    <a4j:commandButton value="Editar" onclick="if(!editarCampania('form1:dataProgramaPeriodo')){return false;}" styleClass="btn" oncomplete="window.location.href='editarCampaniaProgramaProduccion.jsf?data='+(new Date()).getTime().toString()"
                    action="#{ManagedCampanasProgramaProduccion.editarCampaniaProgramaProduccion_action}"/>
                    <a4j:commandButton value="Eliminar" onclick="if(!editarCampania('form1:dataProgramaPeriodo')){return false;}else{if(!confirm('Esta seguro de eliminar la campaña')){return false;}}" action="#{ManagedCampanasProgramaProduccion.eliminarCampaniaProgramaProduccion_action}" styleClass="btn"
                    oncomplete="if(#{ManagedCampanasProgramaProduccion.mensaje eq '1'}){alert('Se elimino la campaña');}
                    else{alert('#{ManagedCampanasProgramaProduccion.mensaje}')}" reRender="dataProgramaPeriodo"/>
                    <a4j:commandButton value="Cancelar"  styleClass="btn"
                    oncomplete="window.location.href='navegadorCampaniaProgramaProduccion.jsf?data='+(new Date()).getTime().toString();" />
                    </div>
                </div>
                    

            </a4j:form>
            
            
        </body>
    </html>
    
</f:view>

