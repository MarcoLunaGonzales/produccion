<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    
    <html>
        <head>
            <title></title>
            <script type="text/javascript" src="../js/general.js"></script>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" /> 
            <script>
                function validar(){
                   if(!(parseInt(document.getElementById('form1:cantidad').value)>0))
                       {
                           alert('La cantidad del Lote no puede ser menor o igual a cero');
                           return false;

                       }
                   return true;
                }
                function retornarNavegador(codigo)
                {
                    var direccion=(codigo>0?"navegadorVersionesFormulaMaestra":"navegadorNuevasFormulas");
                    var b=Math.random();
                    window.location.href=direccion+".jsf?code"+codigo+"="+b;
                }
                
            </script>
        </head>
        <body >
            <a4j:form id="form1"  >
                <div align="center">
                    <br><br>
                    <h:panelGrid columns="3" styleClass="panelgrid" headerClass="headerClassACliente">
                        <f:facet name="header" >
                            <h:outputText value="Editar Formula Maestra" styleClass="outputText2" style="color:#FFFFFF"   />
                        </f:facet>      
                        
                        <h:outputText styleClass="outputText2" value="Producto"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:outputText styleClass="outputText2" value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionEditar.componentesProd.nombreProdSemiterminado}"
                        rendered="#{!ManagedVersionesFormulaMaestra.formulaMaestraVersionEditar.modificacionNF}"/>
                        <h:selectOneMenu  styleClass="inputText" value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionEditar.componentesProd.codCompprod}"
                        rendered="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionEditar.modificacionNF}">
                            <f:selectItems value="#{ManagedVersionesFormulaMaestra.componentesProdSelectList}"/>
                        </h:selectOneMenu>
                        
                        <h:outputText  styleClass="outputText2" value="Cantidad del Lote"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:inputText styleClass="inputText" value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionEditar.cantidadLote}" id="cantidad" onkeypress="valNum();"  />
                        <h:outputText value="Estado" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:selectOneMenu value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionEditar.estadoRegistro.codEstadoRegistro}" styleClass="inputText">
                            <f:selectItem itemLabel="Activo" itemValue="1"/>
                            <f:selectItem itemLabel="No Activo" itemValue="2"/>
                        </h:selectOneMenu>
                    </h:panelGrid>
                    
                    <br>
                        <a4j:commandButton value="Guardar" styleClass="btn"  action="#{ManagedVersionesFormulaMaestra.guardarEdicionVersionFormulaMaestra_action}"   onclick="if(validar()==false){return false;}"
                        oncomplete="if(#{ManagedVersionesFormulaMaestra.mensaje eq '1'}){alert('Se guardo la edicion de la version');retornarNavegador(#{ManagedVersionesFormulaMaestra.formulaMaestraVersionEditar.codFormulaMaestra});}
                    else{alert('#{ManagedVersionesFormulaMaestra.mensaje}')}"/>
                    <a4j:commandButton value="Cancelar" styleClass="btn"   oncomplete="retornarNavegador(#{ManagedVersionesFormulaMaestra.formulaMaestraVersionEditar.codFormulaMaestra});"/>
                    
                </div>
                
                <h:outputText value="#{(ManagedVersionesFormulaMaestra.formulaMaestraVersionEditar.modificacionNF||ManagedVersionesFormulaMaestra.formulaMaestraVersionEditar.modificacionMPEP)?'':'<script>retornarNavegador(1);</script>'}" escape="false"/>
            </a4j:form>
        </body>
    </html>
    
</f:view>

