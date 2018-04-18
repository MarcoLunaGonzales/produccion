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
            </style>
            <script  type="text/javascript">
                function validarBusqueda()
                {
                    if(document.getElementById("form2:loteProduccion").value =='')
                    {
                        
                    }
                    return true;
                }
         </script>
        </head>
        
        <body>
            <a4j:form id="form1">
               
                
                    
                    
                    <h:outputText value="#{ManagedRegistroControlDeCambios.cargarComponentesProdControlCambios}"  />
                    <center>
                    <h:outputText styleClass="outputText2" style="font-weight:bold;font-size:16px"  value="Productos con Control de Cambios" />
                       <rich:dataTable value="#{ManagedRegistroControlDeCambios.componentesProdList}" var="data" id="dataProgramaPeriodo"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" 
                                    style="width=100%" binding="#{ManagedRegistroControlDeCambios.componentesProdDataTable}"
                                    >
                       
                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Producto"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreProdSemiterminado}"  />
                            
                        </rich:column>
                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Nombre Genérico"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreGenerico}"  />
                        </rich:column>
                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Area Empresa"  />
                            </f:facet>
                            <h:outputText value="#{data.areasEmpresa.nombreAreaEmpresa}"  />
                        </rich:column>
                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Forma Farmaceútica"  />
                            </f:facet>
                            <h:outputText value="#{data.forma.nombreForma}"  />
                        </rich:column>
                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Registro Sanitario"  />
                            </f:facet>
                            <h:outputText value="#{data.regSanitario}"  />
                        </rich:column>
                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Vida Util"  />
                            </f:facet>
                            <h:outputText value="#{data.vidaUtil}"  />
                        </rich:column>
                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Cant. Control Cambios" />
                            </f:facet>
                            <h:outputText value="#{data.nroVersion}"  />
                        </rich:column>
                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Control Cambios" />
                            </f:facet>
                            <a4j:commandLink action="#{ManagedRegistroControlDeCambios.seleccionProducto_action}"
                            oncomplete="var a=new Date();window.location.href='navagadorControlesCambio.jsf?date='+a.getTime().toString()">
                                <h:graphicImage url="../img/organigrama3.jpg" alt="Control De Cambios" />
                            </a4j:commandLink>
                        </rich:column>
                        
                        
                                                

                    </rich:dataTable>
                    </center>
                   


                    <br/>
                

                


            </a4j:form>
            
        </body>
    </html>
    
</f:view>

