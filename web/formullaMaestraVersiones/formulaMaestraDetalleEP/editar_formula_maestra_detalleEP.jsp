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
                   var nombreareaempresa=document.getElementById('form1:nombreareaempresa');
                   var obsareaempresa=document.getElementById('form1:obsareaempresa');
                   if(nombreareaempresa.value==''){
                     alert('Por favor instroduzca Nombre Area Empresa');
                     nombreareaempresa.focus();
                     return false;
                   }
                   /*if(obsareaempresa.value==''){
                     alert('Por favor instroduzca datos');
                     obsareaempresa.focus();
                     return false;
                   } */                  
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
           function validarCantidades()
           {
               var tabla=document.getElementById('form1:dataCliente');
               for(var fila=1;fila<tabla.rows.length;fila++)
                   {
                       if(!(parseInt(tabla.rows[fila].cells[1].getElementsByTagName('input')[0].value)>0))
                           {
                               alert('No se puede registrar una cantidad menor o igual a cero en el material '+
                                   tabla.rows[fila].cells[0].getElementsByTagName('span')[0].innerHTML);
                               return false;
                           }
                   }
                   return true;
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
        <body>
            <h:form id="form1"  >
                
                <br>
                
                <div align="center">
                     <br> <br>
                    <h:outputText value="Editar Materiales de:" styleClass="outputText2"   />
                    <h:outputText value="#{ManagedFormulaMaestraDetalleEP.nombreComProd}"   />
                    <br><br><h:outputText value="#{ManagedFormulaMaestraDetalleEP.nombrePresentacion} x  #{ManagedFormulaMaestraDetalleEP.cantidadPresentacion}"  />
                    <br> <br>
                    <rich:dataTable value="#{ManagedFormulaMaestraDetalleEP.formulaMaestraDetalleEPEditarList}" var="data" id="dataCliente" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                    headerClass="headerClassACliente">
                        
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Material"  />
                            </f:facet>
                            <h:outputText value="#{data.materiales.nombreMaterial}" />
                        </h:column>
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Cantidad"  />
                            </f:facet>
                            <h:inputText value="#{data.cantidad}" onkeypress="valNum();">
                                <f:convertNumber pattern="###.##" locale="EN"/>
                            </h:inputText>
                        </h:column>
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Unidad Medida"  />
                            </f:facet>
                            <h:outputText value="#{data.unidadesMedida.nombreUnidadMedida}" />
                        </h:column>
                    </rich:dataTable>
                    <br>
                    <h:commandButton value="Guardar"  styleClass="btn"  onclick="return validarCantidades()" action="#{ManagedFormulaMaestraDetalleEP.guardarEditarFormulaMaestraDetalleEP}"/>
                    <h:commandButton value="Cancelar" styleClass="btn"  action="#{ManagedFormulaMaestraDetalleEP.cancelar}"/>
                    
                    
                </div>
                
                <%@ include file="../WEB-INF/jspx/footer.jsp" %>
            </h:form>
        </body>
    </html>
    
</f:view>

