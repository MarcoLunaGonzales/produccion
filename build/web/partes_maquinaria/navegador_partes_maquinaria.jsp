<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>
    
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src="../js/general.js" ></script> 
            <script>
                function getCodigo(codigo){
                 //  alert(codigo);
                   location='../formulaMaestraDetalleMP/navegador_formula_maestraMP.jsf?codigo='+codigo;
                }
                
                function editarItem(nametable){
                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel.getElementsByTagName('input')[0].checked){
                           count++;
                         }
                         
                     }
                      
                   }
                   if(count==1){
                      return true;
                   } else if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                   }
                   else if(count>1){
                       alert('Solo puede escoger un registro');
                       return false;
                   }                                      
                }


                function asignar(nametable){

                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    alert('hola');
                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel.getElementsByTagName('input')[0].checked){
                           count++;
                         }                         
                     }                      
                   }
                    if(count==0){
                       alert('No selecciono ningun Registro');
                       return false;
                   }else{
                       if(confirm('Desea Asignar como Area Raiz')){
                            if(confirm('Esta seguro de Asignar como Area Raiz')){
                                 return true;
                        }else{
                            return false;
                        }
                    }else{
                        return false;
                    }
                   
                   }
                   
                }          
          function eliminar(nametable){
               var count1=0;
               var elements1=document.getElementById(nametable);
               var rowsElement1=elements1.rows;
               //alert(rowsElement1.length);            
               for(var i=1;i<rowsElement1.length;i++){
                    var cellsElement1=rowsElement1[i].cells;
                    var cel1=cellsElement1[0];
                    if(cel1.getElementsByTagName('input').length>0){
                        if(cel1.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel1.getElementsByTagName('input')[0].checked){
                               count1++;
                           }
                        }
                    }
                    
               }
               //alert(count1);
               if(count1==0){
                    alert('No escogio ningun registro');
                    return false;
               }else{
                
                
                    if(confirm('Desea Eliminar el Registro')){
                        if(confirm('Esta seguro de Eliminar el Registro')){
                            var count=0;
                            var elements=document.getElementById(nametable);
                            var rowsElement=elements.rows;
                            
                            for(var i=0;i<rowsElement.length;i++){
                                var cellsElement=rowsElement[i].cells;
                                var cel=cellsElement[0];
                                if(cel.getElementsByTagName('input').length>0){
                                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                                        if(cel.getElementsByTagName('input')[0].checked){
                                            count++;
                                        }
                                    }
                                }

                            }
                            if(count==0){
                            //alert('No escogio ningun registro');
                            return false;
                            }
                            //var cantidadeliminar=document.getElementById('form1:cantidadeliminar');
                            //cantidadeliminar.value=count;
                            return true;
                        }else{
                            return false;
                        }
                    }else{
                        return false;
                    }
                }
           }                     
                
                                            </script>
        </head>
        <body >
            <h:form id="form1">               
                <div align="center">
                    <h:outputText styleClass="outputTextTitulo"  value="#{ManagedPartesMaquinaria.obtenerCodigo}" />
                    <h:outputText styleClass="outputTextTitulo"  value="Listado de Partes de la Maquina : #{ManagedPartesMaquinaria.nombreMaquinaria}" />                    
                    <br> <br> <br>
                    <rich:dataTable value="#{ManagedPartesMaquinaria.partesMaquinariaList}" var="data" id="dataFormula" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                                    headerClass="headerClassACliente" >
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </h:column>
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="C�digo - Area"  />
                            </f:facet>
                            <h:outputText value="#{data.codigo}"  title="C�digo" />
                        </h:column>
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Elemento"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreParteMaquina}"  title="Parte" />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Tipo Elemento"  />
                            </f:facet>
                            <h:outputText value="#{data.tiposEquiposMaquinaria.nombreTipoEquipo}" title="Tipo de Parte" />
                        </h:column> 
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Descripci�n"  />
                            </f:facet>
                            <h:outputText value="#{data.obsParteMaquina}" title="Observaciones" />
                        </h:column> 
                        
                    </rich:dataTable>
                    
                    <br>
                    <h:commandButton value="Agregar"   styleClass="btn"  action="#{ManagedPartesMaquinaria.actionAgregar}"/>
                    <h:commandButton value="Editar"    styleClass="btn"  action="#{ManagedPartesMaquinaria.actionEditar}" onclick="return editarItem('form1:dataFormula');"/>
                    <h:commandButton value="Eliminar"  styleClass="btn"  action="#{ManagedPartesMaquinaria.guardarEliminarPartesMaquina}"  onclick="return eliminar('form1:dataFormula');"/>                    
                     <h:commandButton value="Cancelar"   styleClass="btn"  action="#{ManagedPartesMaquinaria.cancelar1}"/>
                </div>
                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedPartesMaquinaria.closeConnection}"  />
                
            </h:form>
            
        </body>
    </html>
    
</f:view>

