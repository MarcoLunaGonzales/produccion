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
                var contPopup=0;
              function verCuestionario(codCuestionario,codDocumento,codPersonal){
                    izquierda = (screen.width) ? (screen.width-300)/2 : 100
                    arriba = (screen.height) ? (screen.height-400)/2 : 200
                    var url='navegadorRevisarCuestionario.jsf?codP='+Math.random()+'&codC='+codCuestionario+'&codDoc='+codDocumento+'&codPersonal='+codPersonal;
                     opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,width=700,height=400,left='+izquierda+ ',top=' + arriba + ''
                     contPopup++;
                    // alert(url);
                     window.open(url, ('popUp'+contPopup),opciones);
                    
                }
            </script>
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedDocumentosBiblioteca.cargarCuestionarioPersonal}"/>
                    <h3>Revisión de Cuestionarios</h3>
                    
                    
                    <rich:dataTable value="#{ManagedDocumentosBiblioteca.cuestionarioPersonalList}"
                                    var="data"
                                    id="dataEstadosDocumento"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" style="margin-top:12px;"
                                    >
                        <%--h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                            </f:facet>
                            <h:selectBooleanCheckbox  value="#{data.checked}"  />
                        </h:column--%>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Nombre Documento"  />
                            </f:facet>
                            <h:outputText value="#{data.documentacion.nombreDocumento}"  />
                        </h:column>
                         <h:column>
                            <f:facet name="header">
                                <h:outputText value="Codigo Documento"  />
                            </f:facet>
                            <h:outputText value="#{data.documentacion.codigoDocumento}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Tipo Documento"  />
                            </f:facet>
                            <h:outputText value="#{data.documentacion.tiposDocumentoBiblioteca.nombreTipoDocumentoBiblioteca}"  />
                        </h:column>
                         <h:column>
                            <f:facet name="header">
                                <h:outputText value="Producto"  />
                            </f:facet>
                            <h:outputText value="#{data.documentacion.componentesProd.nombreGenerico}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Maquinaria"  />
                            </f:facet>
                            <h:outputText value="#{data.documentacion.maquinaria.nombreMaquina}"  />
                        </h:column>
                         <h:column>
                            <f:facet name="header">
                                <h:outputText value="Personal"  />
                            </f:facet>
                            <h:outputText value="#{data.personal.nombrePersonal}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Fecha Registro"  />
                            </f:facet>
                            <h:outputText value="#{data.fechaRegistro}">
                                <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                                </h:outputText>
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Fecha Revisión"  />
                            </f:facet>
                            <h:outputText value="#{data.fechaRevision}" rendered="#{data.fechaRevision!=null}">
                                <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                                </h:outputText>
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Revisar"  />
                            </f:facet>
                            <a4j:commandLink  oncomplete="verCuestionario(#{data.codCuestionarioPersonal},#{data.documentacion.codDocumento},#{data.personal.codPersonal})" title="Ver Cuestionario" >
                                        <h:graphicImage url="../../img/folder_32.png"/>
                            </a4j:commandLink>
                                  
                        </h:column>
                       
                    </rich:dataTable>
                   
                    <br>
                        <%--a4j:commandButton value="Registrar" styleClass="btn" action="#{ManagedDocumentosBiblioteca.agregarEstadosDocumento_action}"
                        oncomplete="Richfaces.showModalPanel('panelRegistrarEstadosDocumento')" reRender="contenidoRegistrarEstadosDocumento" />
                        <a4j:commandButton onclick="if(editarItem('form1:dataEstadosDocumento')==false){return false;}" value="Editar" styleClass="btn" action="#{ManagedDocumentosBiblioteca.editarEstadosDocumento_action}"
                        oncomplete="Richfaces.showModalPanel('panelEditarEstadosDocumento')" reRender="contenidoEditarEstadosDocumento" />
                        <a4j:commandButton value="Eliminar" styleClass="btn" onclick="if(confirm('Esta seguro de eliminar el estado documento?')){if(editarItem('form1:dataEstadosDocumento')==false){return false;}}else{return false;}"
                        action="#{ManagedDocumentosBiblioteca.eliminarEstadosDocumento_action}"
                        oncomplete="if(#{ManagedDocumentosBiblioteca.mensaje eq '1'}){alert('Se elimino el estado documento');}else{alert('#{ManagedDocumentosBiblioteca.mensaje}');}" reRender="dataEstadosDocumento"/--%>

                   
                </div>

               
              
            </a4j:form>
            

        </body>
    </html>

</f:view>

