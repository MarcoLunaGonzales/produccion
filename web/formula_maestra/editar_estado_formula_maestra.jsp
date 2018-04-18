<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" /> 
            <script src="../js/general.js"></script>
            <script>
               function validar(){
                   var compronenteProd=document.getElementById('form1:compronenteProd');
                   if(!(parseInt(document.getElementById('form1:cantidad').value)>0))
                       {
                           alert('La cantidad del Lote no puede ser menor o igual a cero');
                           return false;

                       }
                   if(compronenteProd.value==''){
                     alert('Por favor Seleccione un producto para su formula maestra.');
                     compronenteProd.focus();
                     return false;
                   }                   
                   return true;
                }
                           function Material(input,f){
               //alert(input.name);
               var elements=document.getElementById(f);                  
               for(var i=0;i<=elements.length-1;i++){
                  //alert(elements[i].value);
                  //var cellsElement=rowsElement[i].cells;
                  //var cel=elements[i];
                  if (elements[i].name==input.name){
                     alert(input.name);
                     if (elements[i].checked==true){
                       alert("entrooo"+elements[i+1].value);
                       elements[i+1].disabled=false;
                     }
                     else{
                       
                       /*alert("Seleccione el Personal antes de asignar el Monto.");
                       elements[i].value='';
                       event.returnValue = false;*/
                     }
                  }                      
               }  
              
           }           
            </script>
        </head>
        <body>
            <h:form id="form1"  >
                
                
                
                <div align="center">
                    <br><br>
                    <h:panelGrid columns="3" styleClass="panelgrid" headerClass="headerClassACliente">
                        <f:facet name="header" >
                            <h:outputText value="Editar Estado Formula Maestra" styleClass="outputText2" style="color:#FFFFFF"   />
                        </f:facet>
                        
                        <h:outputText  styleClass="outputText2"value="Producto"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:outputText  styleClass="outputText2"value="#{ManagedFormulaMaestra.formulaMaestrabean.componentesProd.nombreProdSemiterminado}"  />
                        
                        <h:outputText  styleClass="outputText2" value="Cantidad del Lote"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:outputText styleClass="inputText" value="#{ManagedFormulaMaestra.formulaMaestrabean.cantidadLote}" id="cantidad"  />
                        <h:outputText value="Tipo Producción" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:outputText value="#{ManagedFormulaMaestra.formulaMaestrabean.componentesProd.tipoProduccion.nombreTipoProduccion}" styleClass="outputText2"   />
                        
                        <h:outputText value="Estado" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:selectOneMenu styleClass="inputText" value="#{ManagedFormulaMaestra.formulaMaestrabean.estadoRegistro.codEstadoRegistro}" >
                            <f:selectItems value="#{ManagedFormulaMaestra.estadoRegistro}"  />
                        </h:selectOneMenu>                         
                    </h:panelGrid>
                    <br>
                    <h:commandButton value="Guardar"  styleClass="btn"  action="#{ManagedFormulaMaestra.guardarEstadoFormulaMaestra_action}"   />
                    <h:commandButton value="Cancelar" styleClass="btn"   action="#{ManagedFormulaMaestra.Cancelar}"/>
                    
                    
                </div>
                
                
            </h:form>
        </body>
    </html>
    
</f:view>

