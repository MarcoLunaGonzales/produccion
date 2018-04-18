package formasFarmaceuticasLote;



<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src='../js/general.js' ></script>
            <script>
                function validar(){
                   var nombreep=document.getElementById('form1:nombreep');
                   if(nombreep.value==''){
                     alert('El Campo Envase Primario esta vacío.');
                     nombreep.focus();
                     return false;
                   }
                   return true;
                }
            </script>
        </head>
        <body>
            <h:form id="form1"  >
                <div align="center">
                    <br>
                    <h:outputText value="Registrar codigo de Lote" styleClass="tituloCabezera1"    />
                    <h:outputText value="#{ManagedFormasFarmLote.cargarContenidoEditarFormasFarmLote}" />

                    <br><br>
                    <h:panelGrid columns="3" styleClass="panelgrid" headerClass="headerClassACliente" style="border:1px solid #0A5B99;">
                        <f:facet name="header" >
                            <h:outputText value="Introduzca  Datos" styleClass="outputText2"    />
                        </f:facet>
                        <h:outputText value="Forma Farmaceutica" styleClass="outputText2"/>
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:selectOneMenu value="#{ManagedFormasFarmLote.formasFarmaceuticasLote.formasFarmaceuticas.codForma}" styleClass="inputText2">
                            <f:selectItems value="#{ManagedFormasFarmLote.formasFarmaceuticasList}" />
                        </h:selectOneMenu>

                        <h:outputText value="Cod. Lote" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:inputText styleClass="inputText"  value="#{ManagedFormasFarmLote.formasFarmaceuticasLote.codLote}"   />

                    </h:panelGrid>
                    <br>
                    <h:commandButton value="Guardar" styleClass="commandButton"   action="#{ManagedFormasFarmLote.guardarEditarFormasFarmLote_action}"  onclick="return validar();"  />
                    <input type="button" value="Cancelar" class="commandButton" onclick="location='navegadorFormasFarmLote.jsf'" />

                </div>
            </h:form>
        </body>
    </html>

</f:view>

