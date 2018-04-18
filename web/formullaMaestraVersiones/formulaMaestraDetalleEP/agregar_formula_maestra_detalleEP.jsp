package formullaMaestraVersiones.formulaMaestraDetalleEP;

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
            function AdicionarItems(nametable){
        
                   var count=0;

                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel.getElementsByTagName('input')[0].checked){
                              if(!(parseInt(cellsElement[2].getElementsByTagName('input')[0].value)>0))
                              {
                                  alert('No se puede registrar una cantidad menor o igual a cero en el material '+cellsElement[1].getElementsByTagName('span')[0].innerHTML);
                                  cellsElement[0].focus();
                                  return false;
                              }
                           count++;
                         }
                         
                     }
                      
                   }

                    if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                }
            /*var cantidadadicionar=document.getElementById('cantidadadicionar');
            cantidadadicionar.value=count;*/
            return true;
           }
           function Item(input,f){
               //alert(input.name);
               var elements=document.getElementById(f);                  
               for(var i=0;i<=elements.length-1;i++){
                  //alert(elements[i].value);
                  //var cellsElement=rowsElement[i].cells;
                  //var cel=elements[i];
                  if (elements[i].name==input.name){
                     //alert(input.name);
                     if (elements[i-1].checked==true){
                       //alert("entrooo");
                     }
                     else{
                       alert("Seleccione el Personal antes de asignar el Monto.");
                       elements[i].value='';
                       event.returnValue = false;
                     }
                  }                      
               }  
               if ((event.keyCode < 48 || event.keyCode > 57) && event.keyCode!=44 && event.keyCode!=45 && event.keyCode!=46)
               {  
                    alert('Introduzca sólo Números');
                    event.returnValue = false;
               }                   
           }
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
            alert(values.length);
             for(var i=0;i<values.length;i++){
                if(values[i].type=='text')
                   values[i].disabled=true; 
             
            }
            alert(values.length);
           }
           function valEnteros()
            {
              if ((event.keyCode < 48 || event.keyCode > 57) )
                 {
                    alert('Introduzca solo Numeros Enteros');
                    event.returnValue = false;
                 }
            }
                                            </script>
        </head>
        <body >
            <h:form id="form1"  >
                
                
                
                <div align="center" class="outputText2">
                    <br><br>
                    Agregar Materiales a : <h:outputText value="#{ManagedFormulaMaestraDetalleEP.nombreComProd}"   />
                    <br><br><h:outputText value="#{ManagedFormulaMaestraDetalleEP.nombrePresentacion} x  #{ManagedFormulaMaestraDetalleEP.cantidadPresentacion}"  />
                    <br><br>
                    <rich:dataTable value="#{ManagedFormulaMaestraDetalleEP.formulaMaestraDetalleEPAdicionarList}"  var="data" id="dataCliente" 
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
                                <h:outputText value="Material"  />
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
                    <h:commandButton  value="Guardar" styleClass="btn"  action="#{ManagedFormulaMaestraDetalleEP.guardarFormulaMaestraDetalleEP}"   onclick="return AdicionarItems('form1:dataCliente');" />
                    <h:commandButton  value="Cancelar" styleClass="btn" action="#{ManagedFormulaMaestraDetalleEP.cancelar}"/>
                    
                    
                    
                </div>
                
                
            </h:form>
        </body>
    </html>
    
</f:view>

