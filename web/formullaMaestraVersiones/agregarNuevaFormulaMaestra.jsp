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
            </script>
        </head>
        <body >
            <a4j:form id="form1"  >
                <h:outputText value="#{ManagedVersionesFormulaMaestra.cargarAgregarNuevaFormulaMaestra}"  />
                <div align="center">
                    <br><br>
                    <h:panelGrid columns="3" styleClass="panelgrid" headerClass="headerClassACliente">
                        <f:facet name="header" >
                            <h:outputText value="Registrar Formula Maestra" styleClass="outputText2" style="color:#FFFFFF"   />
                        </f:facet>      
                        
                        <h:outputText styleClass="outputText2" value="Producto"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:selectOneMenu  styleClass="inputText" value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionAbm.componentesProd.codCompprod}">
                            <f:selectItems value="#{ManagedVersionesFormulaMaestra.componentesProdSelectList}"/>
                        </h:selectOneMenu>
                        
                        <h:outputText  styleClass="outputText2" value="Cantidad del Lote"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:inputText styleClass="inputText" value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionAbm.cantidadLote}" id="cantidad" onkeypress="valNum();"  />
                        <%--h:outputText styleClass="outputText2" value="Tipo Producción"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:selectOneMenu  styleClass="inputText" value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionAbm.componentesProd.tipoProduccion.codTipoProduccion}" >
                            <f:selectItems value="#{ManagedVersionesFormulaMaestra.tiposProduccionSelectList}"/>
                        </h:selectOneMenu--%>

                        <h:outputText value="Estado" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:inputText  styleClass="inputText" disabled="true" value="ACTIVO"/>                            
                    </h:panelGrid>
                    
                    <br>
                    <a4j:commandButton value="Guardar" styleClass="btn"  action="#{ManagedVersionesFormulaMaestra.guardarNuevaFormulaMaestra}"   onclick="if(validar()==false){return false;}"
                    oncomplete="if(#{ManagedVersionesFormulaMaestra.mensaje eq '1'}){alert('Se registro la nueva version'); var a=Math.random();window.location.href='navegadorNuevasFormulas.jsf?a='+a}
                    else{alert('#{ManagedVersionesFormulaMaestra.mensaje}')}"/>
                    <a4j:commandButton value="Cancelar" styleClass="btn"   oncomplete="var a=Math.random();window.location.href='navegadorNuevasFormulas.jsf?a='+a"/>
                    
                </div>
                
               
            </a4j:form>
        </body>
    </html>
    
</f:view>

