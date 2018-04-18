<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>

    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <script type="text/javascript" src="../../js/general.js" ></script>
           <script>
               function openPopup(url1){

                    izquierda = (screen.width) ? (screen.width-300)/2 : 100
                    arriba = (screen.height) ? (screen.height-400)/2 : 200
                    var url=url1+'codP='+Math.random();
                     opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,width=700,height=400,left='+izquierda+ ',top=' + arriba + ''
                    window.open(url, 'popUp',opciones)

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
            function verRegistro(codDocumentacion)
                {
                    document.getElementById('frameSubir').src="subirArchivoPdf.jsf?codDocumentacion="+codDocumentacion+"&a="+Math.random();
                }
                function ocultaRegistro1()
                {
                    Richfaces.hideModalPanel('modalPanelSubirArchivo');
                }
           </script>
           <style>
                .headerLocal{
                    background-image:none;
                    background-color:#9d5f9f;
                    font-weight:bold;
                }
                .celdaVersion{
                    background-color:#eeeeee;
                }
           </style>
        </head>
        <body >
            <a4j:form id="form">
                <div align="center">
                    <h:outputText value="#{ManagedArgumentos.cargarArgumentos}"/>
                     <table align="center" width="70%" class='outputText0'>
                    <tr>
                         <td align="center" >
                            <h3 >Argumentos Productos </h3>
                        </td>
                     </table>
                     <rich:panel headerClass="headerClassACliente" style="width:50%">
                             <f:facet name="header">
                                 <h:outputText value="Datos Producto"/>
                             </f:facet>
                             <h:panelGrid columns="2">
                                 <h:outputText styleClass="outputText2" value="Nombre Producto" style="font-weight:bold"/>
                                 <h:outputText styleClass="outputText2" value="#{ManagedArgumentos.componentesProd.nombreProductoPresentacion}" style="font-weight:bold"/>
                             </h:panelGrid>
                     </rich:panel>
                    
                    
                    <rich:dataTable value="#{ManagedArgumentos.argumentosList}"
                                    var="data"
                                    id="dataArgumentos"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" style="margin-top:12px;">
                            <h:column>
                                <f:facet name="header">
                                    <h:outputText value=""  />
                                </f:facet>
                                <h:selectBooleanCheckbox  value="#{data.checked}"  />
                            </h:column>
                            <h:column>
                                <f:facet name="header">
                                    <h:outputText value="Nombre"  />
                                </f:facet>
                                <h:inputText value="#{data.nombreArgumento}"  styleClass="inputText2" size="40" />
                            </h:column>
                            <h:column>
                                <f:facet name="header">
                                    <h:outputText value="Descripcion"  />
                                </f:facet>
                                <h:inputTextarea value="#{data.descripcionArgumento}"  styleClass="inputText2"  rows="4" cols="50" />
                            </h:column>
                            <h:column>
                                <f:facet name="header">
                                    <h:outputText value="Pregunta"  />
                                </f:facet>
                                <h:inputTextarea value="#{data.descripcionPregunta}"  styleClass="inputText2" rows="4" cols="50" />
                            </h:column>
                            
                            <h:column>
                                <f:facet name="header">
                                    <h:outputText value="Estado"  />
                                </f:facet>
                                <h:selectOneMenu value = "#{data.estadoReferencial.codEstadoRegistro}" >
                                    <f:selectItems value="#{ManagedArgumentos.estadosReferencialesList}" />
                                </h:selectOneMenu>
                            </h:column>
                             
                    </rich:dataTable>
                    <a4j:commandLink accesskey="q" action="#{ManagedArgumentos.mas_action}" id="masAction" reRender="dataArgumentos" timeout="10000" >
                            <h:graphicImage url="../../img/mas.png" alt="mas"/>
                    </a4j:commandLink>
                    <a4j:commandLink accesskey="w" action="#{ManagedArgumentos.menos_action}" reRender="dataArgumentos" timeout="10000">
                            <h:graphicImage url="../../img/menos.png" alt="menos"/>
                    </a4j:commandLink>
                    <br>
                    <a4j:commandButton action="#{ManagedArgumentos.guardarArgumentos_action}" styleClass="btn" value="Guardar" oncomplete="location = 'navegadorProductos.jsf'"/>
                        
                        

                   
                </div>

               
              
            </a4j:form>
            
                    
            

        </body>
    </html>

</f:view>

