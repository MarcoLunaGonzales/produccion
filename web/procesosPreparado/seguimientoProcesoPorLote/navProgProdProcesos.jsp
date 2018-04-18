<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>
    <!DOCTYPE html>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <script type="text/javascript" src="../../js/general.js" ></script>
            <style  type="text/css">
                 .codcompuestoprod{
                background-color:#ADD797;
                }.nocodcompuestoprod{
                background-color:#FFFFFF;
                }
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
                    color:white;
                    height:80px !important;
                    text-align:center;

                }
                .celdaVersion{
                    background-color:#eeeeee;
                }
                 .floatLeft
                {
                    position: relative;
                    height: 281px;
                    float: left;
                    overflow: hidden;
                }

            .tablaDetalle
            {
                position:relative;
                height: 300px;
                float:left;
                width: 700px;
                left: 0px;


            }
            .cabeceraDetalle
            {
                width: 681px;
                overflow-y: hidden;
                overflow-x: hidden;
            }
            .divTabla
            {
                float:left;
                text-align:left;
            }
            .divTabla table tr td
            {
                height: 50px;
                border: 1px solid black;
                border-collapse: collapse;
                padding: 4px;
            }
            table
            {
                border-collapse: collapse;
            }
            </style>
              <script>
                  function verReporte(codHoja,codProgramaProd,codLote,codReceta,codForma)
            {
                var urlHoja='';
                switch(codHoja)
                {
                    case 1:urlHoja='reporteLimpiezaAmbiente.jsf';
                           break;
                    case 2:urlHoja='reporteRepesada.jsf';
                           break;
                    case 3:urlHoja=(codForma==2?'reporteLavado.jsf':'reporteLavadoColirios.jsf');
                           break;
                    case 4:urlHoja='reporteDespirogenizado.jsf';
                           break;
                    case 5:urlHoja='reportePreparado.jsf';
                           break;
                    case 6:urlHoja=(codForma==2?'reporteDosificado.jsf':'reporteDosificadoColirios.jsf');
                           break;
                    case 7:urlHoja=(codForma==2?'reporteControlLLenadoVolumen.jsf':'reporteControlPeso.jsf');
                           break;
                    case 8:urlHoja=(codForma==2?'reporteControlDosificado.jsf':'reporteControlDosificadoColirios.jsf');
                           break;
                    case 9:urlHoja='reporteRendimientoDosificado.jsf';
                           break;
                    case 10:urlHoja='reporteEsterilizacionCalorHumedo.jsf';
                           break;
                    case 11:urlHoja='reporteGeneral.jsf';
                           break;
                    case 12:urlHoja='reporteGrafadoFrascos.jsf';
                           break;
                    default:urlHoja='';
                           break;
                }
                urlHoja='hojasOM/'+urlHoja+"?codLote="+codLote+"&codProgramaProd="+codProgramaProd+
                    "&data="+(new Date()).getTime().toString()+"&codReceta="+codReceta+"&imp=0&codForma="+codForma;

                window.open(urlHoja,('hoja'+(new Date()).getTime().toString()),'top=50,left=200,width=800,height=500,scrollbars=1,resizable=1');

            }
                  var cod=0;
                function openPopup(url,nombre){
                    //alert(url);
                    
                    url+='&ale='+Math.random();
                    cod++;
                    //alert(url);
                    window.open(url,('DETALLE'+nombre+cod),'top=50,left=200,width=800,height=500,scrollbars=1,resizable=1');
                }
                function cargar()
                {
                    var dataCabeceraFija=document.getElementById("dataCabeceraFija");
                    var tabla=document.getElementById("divTablaDetalle");
                    var divCabecera=document.getElementById("dataCabecera");
                    try
                    {
                        dataCabeceraFija.removeChild(dataCabeceraFija.getElementsByTagName("table")[0]);
                        divCabecera.removeChild(divCabecera.getElementsByTagName("table")[0]);
                    }
                    catch(e){}

                    var tablaCabeceraFija=document.createElement("table");
                    var tablaFilaFija=document.getElementById("divLeft").getElementsByTagName("table")[0];
                    var filaCabeceraFilaFila=tablaCabeceraFija.insertRow(0);
                    for(var i=0;i<tablaFilaFija.rows[0].cells.length;i++)
                    {
                         var celdaFila=filaCabeceraFilaFila.insertCell(i);
                         celdaFila.className='headerLocal';
                         celdaFila.innerHTML=tablaFilaFija.rows[0].cells[i].innerHTML;
                         tablaFilaFija.rows[0].cells[i].style.display='none';
                    }
                    dataCabeceraFija.appendChild(tablaCabeceraFija);
                    tablaFilaFija.deleteRow(0);
                    try
                    {
                        for(var i=0;i<tablaFilaFija.rows[0].cells.length;i++)
                        {
                             var tamCelda=(tablaCabeceraFija.rows[0].cells[i].clientWidth>tablaFilaFija.rows[0].cells[i].clientWidth?tablaCabeceraFija.rows[0].cells[i].clientWidth:tablaFilaFija.rows[0].cells[i].clientWidth);
                             tablaCabeceraFija.rows[0].cells[i].style.width=tamCelda;
                             tablaFilaFija.rows[0].cells[i].style.width=tamCelda;

                        }
                        tablaCabeceraFija.style.tableLayout="fixed";
                        tablaFilaFija.style.tableLayout="fixed";
                    }catch(e){}

                    var tablaCabecera=document.createElement("table");
                    var fila=tablaCabecera.insertRow(0);
                    var tablaDetalle=tabla.getElementsByTagName("table")[0];
                    for(var i=0;i<tablaDetalle.rows[0].cells.length;i++)
                    {
                        var celda=fila.insertCell(i);
                        celda.className='headerLocal';
                        celda.innerHTML=tablaDetalle.rows[0].cells[i].innerHTML;
                        tablaDetalle.rows[0].cells[i].style.display='none';
                    }
                    tablaDetalle.deleteRow(0);

                    divCabecera.appendChild(tablaCabecera);
                    try
                    {
                        for(var i=0;i<tablaDetalle.rows[0].cells.length;i++)
                        {
                            var tamCelda=(tablaCabecera.rows[0].cells[i].clientWidth>tablaDetalle.rows[0].cells[i].clientWidth?tablaCabecera.rows[0].cells[i].clientWidth:tablaDetalle.rows[0].cells[i].clientWidth);
                             tablaCabecera.rows[0].cells[i].style.width=tamCelda;
                             tablaDetalle.rows[0].cells[i].style.width=tamCelda;
                        }
                        tablaCabecera.style.tableLayout="fixed";
                        tablaDetalle.style.tableLayout="fixed";
                    }catch(e){}
                    tabla.onscroll=function()
                    {
                        document.getElementById("divLeft").scrollTop=tabla.scrollTop;
                        document.getElementById("dataCabecera").scrollLeft=tabla.scrollLeft;
                    }
                }
            </script>
        </head>
        
            
            
            <a4j:form id="form1">
                <div align="center">
                    
                    <h:outputText value="#{ManagedSeguimientoProcesosPorLote.cogerCodProgProdPeriodo}"  />
                    <h:outputText styleClass="outputTextTitulo"  value="Programas de Producción" />
                    <br><br>
                  
                        <h:panelGroup id="contenidoProgramaProduccion">

                      <table cellpadding="0px" cellspacing="0px"><tr><td style="vertical-align:top">
                            <div class="divTabla">
                                <div id="dataCabeceraFija"></div>
                                <div class="floatLeft" id="divLeft">
                                    <rich:dataTable value="#{ManagedSeguimientoProcesosPorLote.seguimientoPreparadoLoteList}" var="data" id="dataNombresProducto"
                                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                                    headerClass="" >
                                            <f:facet name="header">
                                                <rich:columnGroup >
                                                    <rich:column>
                                                        <h:outputText value="Producto" escape="false"   />
                                                    </rich:column>
                                                    <rich:column>
                                                        <h:outputText value="Lote" escape="false"   />
                                                    </rich:column>
                                                    <rich:column>
                                                        <h:outputText value="<center>Nro de<br>Lote</center>" escape="false"   />
                                                    </rich:column>
                                                    <rich:column>
                                                        <h:outputText value="<center>Programa<br>Produccion</center>" escape="false"   />
                                                    </rich:column>
                                                    <rich:column>
                                                        <h:outputText value="<center>Estado</center>" escape="false"   />
                                                    </rich:column>
                                                </rich:columnGroup>
                                            </f:facet>
                                                 <rich:column >
                                                    <h:outputText value="#{data.programaProduccion.formulaMaestra.componentesProd.nombreProdSemiterminado}"  />
                                                </rich:column>
                                                <rich:column >
                                                    <h:outputText value="#{data.programaProduccion.cantidadLote}"  />
                                                </rich:column>

                                                <rich:column >
                                                    <h:outputText value="#{data.programaProduccion.codLoteProduccion}"  />
                                                </rich:column >
                                                <rich:column >
                                                    <h:outputText value="#{data.programaProduccion.programaProduccionPeriodo.nombreProgramaProduccion}"  />
                                                </rich:column >
                                                <%--rich:column >
                                                    <h:outputText value="#{data.programaProduccion.formulaMaestra.componentesProd.areasEmpresa.nombreAreaEmpresa}"/>
                                                </rich:column--%>
                                                <rich:column >
                                                    <h:outputText value="#{data.programaProduccion.estadoProgramaProduccion.nombreEstadoProgramaProd}" />
                                                </rich:column >
                        </rich:dataTable>
                          </div>
                    </div>
                        </td><td>
                    <div class="divTabla">
                        <div id="dataCabecera" class="cabeceraDetalle"></div>
                            <div class="tablaDetalle" >
                                <div style="overflow:scroll;max-height:100%;min-height:0%" id="divTablaDetalle">
                        <rich:dataTable value="#{ManagedSeguimientoProcesosPorLote.seguimientoPreparadoLoteList}" var="data" id="dataProgramaproduccionList"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="" >
                        <f:facet name="header">
                            <rich:columnGroup >
                                <rich:column>
                                    <h:outputText value="<center>Cuali-<br>Cuantitativa</center>" escape="false"   />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="<center>Proceso<br>Limpieza</center>" escape="false"   />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="<center>Proceso<br>Repesada</center>" escape="false"   />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="<center>Proceso<br>Lavado</center>" escape="false"   />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="<center>Proceso<br>Despiro.</center>" escape="false"   />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="<center>Proceso<br>Preparado</center>" escape="false"   />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="<center>Proceso<br>Dosificado</center>" escape="false"   />
                                </rich:column>
                                 <rich:column>
                                    <h:outputText value="<center>Grafado<br>Frascos</center>" escape="false"   />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="<center>Proceso Cont.<br> LLenado Vol.</center>" escape="false"   />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="<center>Control<br> Dosificado</center>" escape="false"   />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="<center>Rend. Dosif.</center>" escape="false"   />
                                </rich:column>
                                 <rich:column>
                                    <h:outputText value="<center>Est. Calor<br> Humedo</center>" escape="false"   />
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                       
                        <rich:column style="text-align:center" >
                                <a4j:commandLink styleClass="outputText2" onclick="openPopup('seguimientoProcesosEspecificaciones/navegadorCualicuanti.jsf?codProgProd=#{data.programaProduccion.programaProduccionPeriodo.codProgramaProduccion}&codComprod=#{data.programaProduccion.formulaMaestra.componentesProd.codCompprod}&codLote=#{data.programaProduccion.codLoteProduccion}&codAreaEmpresa=#{data.programaProduccion.formulaMaestra.componentesProd.areasEmpresa.codAreaEmpresa}','Cualicuantitativa')">
                                     <h:graphicImage url="../../img/preparado.jpg" title="Formula Cuali-Cuantitativa"/>
                                 </a4j:commandLink>
                        </rich:column>
                        <rich:column style="text-align:center" >
                            <a4j:commandLink styleClass="outputText2"
                            onclick="verReporte(1,'#{data.programaProduccion.programaProduccionPeriodo.codProgramaProduccion}','#{data.programaProduccion.codLoteProduccion}',1,'#{data.programaProduccion.formulaMaestra.componentesProd.forma.codForma}')">
                                 <h:graphicImage url="../../img/limpieza.gif" title="Proceso Limpieza"/>
                             </a4j:commandLink>
                        </rich:column>
                        <rich:column style="text-align:center" >
                            <a4j:commandLink styleClass="outputText2"
                            onclick="verReporte(2,'#{data.programaProduccion.programaProduccionPeriodo.codProgramaProduccion}','#{data.programaProduccion.codLoteProduccion}',1,'#{data.programaProduccion.formulaMaestra.componentesProd.forma.codForma}')">
                                 <h:graphicImage url="../../sistemaTouch/reponse/img/repesada.jpg" title="Proceso Limpieza"/>
                             </a4j:commandLink>
                        </rich:column>
                        <rich:column style="text-align:center" >
                            <a4j:commandLink styleClass="outputText2"
                            onclick="verReporte(3,'#{data.programaProduccion.programaProduccionPeriodo.codProgramaProduccion}','#{data.programaProduccion.codLoteProduccion}',1,'#{data.programaProduccion.formulaMaestra.componentesProd.forma.codForma}')">
                                 <h:graphicImage url="../../img/lavado.gif" title="Proceso Limpieza"/>
                             </a4j:commandLink>
                        </rich:column>
                        <rich:column style="text-align:center"  >
                            <a4j:commandLink styleClass="outputText2" rendered="#{data.programaProduccion.formulaMaestra.componentesProd.forma.codForma eq '2'}"
                            onclick="verReporte(4,'#{data.programaProduccion.programaProduccionPeriodo.codProgramaProduccion}','#{data.programaProduccion.codLoteProduccion}',1,'#{data.programaProduccion.formulaMaestra.componentesProd.forma.codForma}')">
                                 <h:graphicImage url="../../img/despirogenizado.gif" title="Proceso Limpieza"/>
                             </a4j:commandLink>
                        </rich:column>
                        <rich:column style="text-align:center" >
                            <a4j:commandLink styleClass="outputText2"
                            onclick="verReporte(5,'#{data.programaProduccion.programaProduccionPeriodo.codProgramaProduccion}','#{data.programaProduccion.codLoteProduccion}',1,'#{data.programaProduccion.formulaMaestra.componentesProd.forma.codForma}')">
                                 <h:graphicImage url="../../sistemaTouch/reponse/img/preparado.jpg" title="Proceso Limpieza"/>
                             </a4j:commandLink>
                        </rich:column>
                        <rich:column style="text-align:center" >
                            <a4j:commandLink styleClass="outputText2"
                            onclick="verReporte(6,'#{data.programaProduccion.programaProduccionPeriodo.codProgramaProduccion}','#{data.programaProduccion.codLoteProduccion}',1,'#{data.programaProduccion.formulaMaestra.componentesProd.forma.codForma}')">
                                 <h:graphicImage url="../../img/dosificado.gif" title="Proceso Limpieza"/>
                             </a4j:commandLink>
                        </rich:column>
                        <rich:column style="text-align:center" >
                            <a4j:commandLink styleClass="outputText2" rendered="#{data.programaProduccion.formulaMaestra.componentesProd.forma.codForma eq '25'}"
                            onclick="verReporte(12,'#{data.programaProduccion.programaProduccionPeriodo.codProgramaProduccion}','#{data.programaProduccion.codLoteProduccion}',1,'#{data.programaProduccion.formulaMaestra.componentesProd.forma.codForma}')">
                                 <h:graphicImage url="../../img/grafado.gif" title="Proceso Limpieza"/>
                             </a4j:commandLink>
                        </rich:column>
                        <rich:column style="text-align:center" >
                            <a4j:commandLink styleClass="outputText2" 
                            onclick="verReporte(7,'#{data.programaProduccion.programaProduccionPeriodo.codProgramaProduccion}','#{data.programaProduccion.codLoteProduccion}',1,'#{data.programaProduccion.formulaMaestra.componentesProd.forma.codForma}')">
                                 <h:graphicImage url="../../img/controllenado.gif" title="Proceso Limpieza"/>
                             </a4j:commandLink>
                        </rich:column>
                        <rich:column style="text-align:center" >
                            <a4j:commandLink styleClass="outputText2"
                            onclick="verReporte(8,'#{data.programaProduccion.programaProduccionPeriodo.codProgramaProduccion}','#{data.programaProduccion.codLoteProduccion}',1,'#{data.programaProduccion.formulaMaestra.componentesProd.forma.codForma}')">
                                 <h:graphicImage url="../../img/controlDosificado.gif" title="Proceso Limpieza"/>
                             </a4j:commandLink>
                        </rich:column>
                        <rich:column style="text-align:center" >
                            <a4j:commandLink styleClass="outputText2"
                            onclick="verReporte(9,'#{data.programaProduccion.programaProduccionPeriodo.codProgramaProduccion}','#{data.programaProduccion.codLoteProduccion}',1,'#{data.programaProduccion.formulaMaestra.componentesProd.forma.codForma}')">
                                 <h:graphicImage url="../../img/rendimiento.gif" title="Proceso Limpieza"/>
                             </a4j:commandLink>
                        </rich:column>
                        <rich:column style="text-align:center" >
                            <a4j:commandLink styleClass="outputText2"
                            onclick="verReporte(10,'#{data.programaProduccion.programaProduccionPeriodo.codProgramaProduccion}','#{data.programaProduccion.codLoteProduccion}',1,'#{data.programaProduccion.formulaMaestra.componentesProd.forma.codForma}')">
                                 <h:graphicImage url="../../img/esterilizacion.gif" title="Proceso Limpieza"/>
                             </a4j:commandLink>
                        </rich:column>
                    </rich:dataTable>
                     </div>
                        </div></div></td></tr></table>
                    <br>
                    </h:panelGroup>
                    </div>
                    <h:outputText value="<script>cargar();</script>" escape="false"/>
                    </a4j:form>
                   <%--a4j:status id="statusPeticion"
                                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
                    </a4j:status>

                    <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                                     minWidth="200" height="80" width="400" zindex="100" onshow="window.focus();">

                        <div align="center">
                            <h:graphicImage value="../../img/load2.gif" />
                        </div>
                    </rich:modalPanel--%>
                    

            
        </body>
    </html>
    
</f:view>

