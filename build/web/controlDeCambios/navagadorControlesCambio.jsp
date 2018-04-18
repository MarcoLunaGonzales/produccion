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
                .a{
                background-color : #F2F5A9;
                }
                .b{
                background-color : #ffffff;
                }
                .columns{
                border:0px solid red;
                }
                .simpleTogglePanel{
                text-align:center;
                }
                .ventasdetalle{
                font-size: 13px;
                font-family: Verdana;
                }
                .preciosaprobados{
                background-color:#33CCFF;
                }
                .enviado{
                background-color:#FFFFCC;
                }
                .pasados{
                background-color:#ADD797;
                }
                .pendiente{
                background-color : #ADD797;
                }
                .leyendaColorAnulado{
                background-color: #FF6666;
                }
                .oos
                {
                   background-color:#90EE90;
                }
            </style>
            <script  type="text/javascript">
                function openPopup(url){
                       window.open(url,'detalle'+Math.round((Math.random()*1000)),'top=50,left=200,width=800,height=600,scrollbars=1,resizable=1');
                }
                function verFormatoImpresionOOS(codControlDeCambios)
                {
                    urlOOS="reporteControlDeCambios.jsf?codControlCambios="+codControlDeCambios+"&date="+(new Date()).getTime().toString()+"&ale="+Math.random();
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
         </script>
        </head>
             <a4j:form id="form1">
                <div align="center">
                    
                    <h:outputText value="#{ManagedRegistroControlDeCambios.cargarControldeCambiosProducto}"  />
                    <h:outputText styleClass="outputText2" style="font-weight:bold;font-size:14px" value="Controles de Cambio" />

                        <rich:panel style="width:50%;margin-top:12px; " headerClass="headerClassACliente">
                            <f:facet name="header">
                                <h:outputText value="Datos del Programa Produccion"/>
                            </f:facet>
                                <h:panelGrid columns="3">
                                    <h:outputText value="Producto" styleClass="outputText2" style="font-weight:bold"/>
                                    <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                                    <h:outputText value="#{ManagedRegistroControlDeCambios.componentesProdSeleccionado.nombreProdSemiterminado}" styleClass="outputText2" />
                                    <h:outputText value="Nombre Genérico" styleClass="outputText2" style="font-weight:bold"/>
                                    <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                                    <h:outputText value="#{ManagedRegistroControlDeCambios.componentesProdSeleccionado.nombreGenerico}"  styleClass="outputText2" />
                                    
                                </h:panelGrid>
                        </rich:panel>
                        <rich:dataTable value="#{ManagedRegistroControlDeCambios.registroControlCambiosList}" style="margin-top:12px;" var="data" id="dataFormula"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" 
                                    binding="#{ManagedRegistroControlDeCambios.registroControlCambiosData}"
                                    >
                      

                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Correlativo"  />
                            </f:facet>
                            <h:outputText value="#{data.coorelativo}"  />
                        </rich:column>
                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Funcionario"  />
                            </f:facet>
                            <h:outputText value="#{data.personalRegistra.nombrePersonal}"  />
                        </rich:column>
                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Producto"  />
                            </f:facet>
                            <h:outputText value="#{data.componentesProd.nombreProdSemiterminado}"  />
                        </rich:column>
                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Area Empresa"  />
                            </f:facet>
                            <h:outputText value="#{data.areasEmpresa.nombreAreaEmpresa}"  />
                        </rich:column>
                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Fecha"  />
                            </f:facet>
                            <h:outputText value="#{data.fechaRegistro}">
                                <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                            </h:outputText>
                        </rich:column>
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Proposito del<br>cambio"  escape="false" />
                            </f:facet>
                            <h:outputText value="#{data.propositoCambio}"  />
                        </rich:column>
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Control de Cambios"  />
                            </f:facet>
                            <a4j:commandLink action="#{ManagedRegistroControlDeCambios.seleccionRegistroControlCambios_select}"
                            oncomplete="var ad=Math.random();window.location.href='revisionControlCambios.jsf?cod'+ad;">
                                <h:graphicImage url="../img/organigrama3.jpg" alt="Control OS" />
                            </a4j:commandLink>
                        </rich:column>
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Impresion"  />
                            </f:facet>
                            <a4j:commandLink oncomplete="verFormatoImpresionOOS('#{data.codRegistroControlCambios}');" >
                                <h:graphicImage url="../img/organigrama3.jpg" alt="Registro Control de Cambios" />
                            </a4j:commandLink>
                        </rich:column>

                    </rich:dataTable>
                    
                    <br>
                   
                   
                    

            </a4j:form>
            
            
        </body>
    </html>
    
</f:view>

