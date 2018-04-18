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
           </script>
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedDocumentosBiblioteca.cargarPreguntasDocumentacion}"/>
                     <table align="center" width="70%" class='outputText0'>
                    <tr>
                        <td width="10%">
                            <img src="../../img/cofar.png">
                        </td>
                         <td align="center" >
                            <h3 >Documentos Biblioteca</h3>
                        </td>
                     </table>
                    
                    
                    <rich:dataTable value="#{ManagedDocumentosBiblioteca.documentacionPreguntasList}"
                                    var="data"
                                    id="dataDocumentacion" binding="#{ManagedDocumentosBiblioteca.documentacionPreguntaDataTable}"
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
                                <h:outputText value="Descripcion"  />
                            </f:facet>
                            <h:outputText value="#{data.descripcionPregunta}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoReferencial.nombreEstadoRegistro}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                            </f:facet>
                            <a4j:commandLink action="#{ManagedDocumentosBiblioteca.seleccionarPregunta_action}" oncomplete=" var a=Math.random();window.location.href='navegadorRespuestasDocumentacion.jsf?a='+a;" title="Ver respuestas de documentacion" >
                                <h:graphicImage url="../../img/pdfUsuario.jpg"/>
                            </a4j:commandLink>
                        </h:column>
                    </rich:dataTable>
                   
                    <br/>
                    
                       
                        
                </div>
            </a4j:form>

            
            

        </body>
    </html>

</f:view>

