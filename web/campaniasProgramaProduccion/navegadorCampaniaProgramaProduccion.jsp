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
         </script>
        </head>
             <a4j:form id="form1">
                <div align="center">
                    
                    <h:outputText value="#{ManagedCampanasProgramaProduccion.cargarProgramaProduccionPeriodo}"  />
                    <h:outputText styleClass="outputTextTitulo"  value="Programas de Producción" />

                        <h:panelGroup id="contenidoProgramaProduccion">
                        
                        <rich:dataTable value="#{ManagedCampanasProgramaProduccion.programaProduccionPeriodoList}"
                                    style="margin-top:12px;width:70%" var="data" id="dataProgramaPeriodo"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" 
                                    binding="#{ManagedCampanasProgramaProduccion.programaProduccionPeriodoDataTable}">
                      

                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Programa Produccion"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreProgramaProduccion}"  />
                        </rich:column>
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Observacion"  />
                            </f:facet>
                            <h:outputText value="#{data.obsProgramaProduccion}"  />
                        </rich:column>
                        
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Detalle"  />
                            </f:facet>
                            <a4j:commandLink oncomplete="window.location.href='navegadorLotesCampaniaProgramaProduccion.jsf?data='+(new Date()).getTime().toString()"
                            action="#{ManagedCampanasProgramaProduccion.seleccionarProgramaProduccionPeriodo}">
                                <h:graphicImage url="../img/organigrama3.jpg" alt="Control OS" />
                            </a4j:commandLink>
                        </rich:column>

                    </rich:dataTable>
                    
                    <br>
                   
                    </h:panelGroup>
                   
                    

            </a4j:form>
            
            
        </body>
    </html>
    
</f:view>

