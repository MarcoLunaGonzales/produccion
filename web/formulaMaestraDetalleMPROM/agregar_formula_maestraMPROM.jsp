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

           
               function Material(input,f){
               //alert(input.name);
               var elements=document.getElementById(f);                  
               for(var i=0;i<=elements.length-1;i++){
                  //alert(elements[i].value);
                  //var cellsElement=rowsElement[i].cells;
                  //var cel=elements[i];
                  if (elements[i].name==input.name){
                     //alert(input.name);
                     if (elements[i].checked==true){
                       //alert("entrooo"+elements[i+1].value);
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
           
            function cr(){
            var values=document.body.getElementsByTagName('input');
            
             for(var i=0;i<values.length;i++){
                if(values[i].type=='text')
                   values[i].disabled=true; 
             
            }
            //alert(values.length);
           }
           
                                            </script>
        </head>
        <body >
            <h:form id="form1"  >
                
                
                
                <div align="center" class="outputText2">
                    <br><br>
                    Agregar Material Promocional a :<h:outputText value="#{ManagedFormulaMaestraDetalleMPROM.nombreComProd}"   />
                    <br><br>
                    <rich:dataTable value="#{ManagedFormulaMaestraDetalleMPROM.formulaMaestraDetalleMPROMAdicionarList}"  var="data" id="dataCliente" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 

                                    headerClass="headerClassACliente">
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}" onclick="Material(this,'form1')"  />
                        </h:column>
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Material Promocional"  />
                            </f:facet>
                            <h:outputText value="#{data.materiales.nombreMaterial}"  />
                        </h:column>
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Cantidad"   />
                            </f:facet>
                            <h:inputText value="#{data.cantidad}" styleClass="inputText"  onkeypress="valNum();"/>
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Unidad Medida"  />
                            </f:facet>
                            <h:outputText value="#{data.unidadesMedida.abreviatura}"  />
                        </h:column>
                        
                        
                    </rich:dataTable>
                    <br>
                    <h:commandButton  value="Guardar" styleClass="btn"  action="#{ManagedFormulaMaestraDetalleMPROM.guardarFormulaMaestraDetalleMPROM}"   onclick="return AdicionarItems('form1:dataCliente');" />
                    <h:commandButton  value="Cancelar" styleClass="btn" action="#{ManagedFormulaMaestraDetalleMPROM.cancelar}"/>
                    
                    
                    
                </div>
                
                
            </h:form>
        </body>
    </html>
    
</f:view>

