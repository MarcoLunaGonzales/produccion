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
                function cogerId(obj){
                    alert(obj);
                   
                  
                }
                function getCodigo(codigo,codFormula,nombre,cantidad,codComProd,codLote){
                
                  izquierda = (screen.width) ? (screen.width-300)/2 : 100 
                  arriba = (screen.height) ? (screen.height-400)/2 : 200 		
                  //url='../configuracionReporte/navegadorConfiguracionReporteReplica.jsf?codigo='+cod+'';			
                  url='detalle_navegador_programa_prod.jsf?codigo='+codigo+'&codFormula='+codFormula+'&nombre='+nombre+'&cantidad='+cantidad+'&cod_comp_prod='+codComProd+'&cod_lote='+codLote;
                  opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=700,height=400,left='+izquierda+ ',top=' + arriba + '' 
                  window.open(url, 'popUp',opciones)

                }
                function getCodigoReserva(codigo){
                
                  		
                  location='../reporteExplosionProductos/guardarReservaProgramaProd.jsf?codigo='+codigo;


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

   function nuevoAjax()
    {	var xmlhttp=false;
                try {
                        xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
                    } catch (e) {
                    try {
 			xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
                    } catch (E) {
                        	xmlhttp = false;
                    }                    
                    }
                    if (!xmlhttp && typeof XMLHttpRequest!="undefined") {
                       xmlhttp = new XMLHttpRequest();
                    }
                    return xmlhttp;
     }
     function enviar(codigo,fecha_ini,fecha_fin){
        //alert();
            
        var ajax=nuevoAjax();
        var valores='codigos='+codigo+'&fecha_inicio='+fecha_ini+'&fecha_final='+fecha_fin;
        valores+='&pq='+(Math.random()*1000);
        
        var url='../reporteExplosionProductos/filtroReporteExplosion.jsf';
       
        
        
        //alert(url);
        ajax.open ('POST', url, true);
        ajax.onreadystatechange = function() {
       
           if (ajax.readyState==1) {
            
           }else if(ajax.readyState==4){
                // alert(ajax.status);
                if(ajax.status==200){
                    //alert(ajax.responseText);
                    var mainGrupo=document.getElementById('panelCenter');
                    //mainGrupo.innerHTML=ajax.responseText;
                    document.write(ajax.responseText);
                    
                    //f=0;
                    //Item(codigo,f);
                }
           }
        }
        ajax.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
        ajax.send(valores);
    }
    
    
    function seleccionarTodo(){
       //alert('entro');
       var seleccionar_todo=document.getElementById('form1:seleccionar_todo');
       var elements=document.getElementById('form1:dataFormula');

       if(seleccionar_todo.checked==true){  
         //alert('entro por verdad');
            var rowsElement=elements.rows;
            for(var i=1;i<rowsElement.length;i++){
                var cellsElement=rowsElement[i].cells;
                var cel=cellsElement[0];
                if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                    cel.getElementsByTagName('input')[0].checked=true;
                }
            }
       }
       else
       {//alert('entro por false');
            var rowsElement=elements.rows;
            for(var i=1;i<rowsElement.length;i++){
                var cellsElement=rowsElement[i].cells;
                var cel=cellsElement[0];
                if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                    cel.getElementsByTagName('input')[0].checked=false;
                }
            }

       }
       return true;

    }                           
                
                
                                            </script>
        </head>
        <body >
            <a4j:form id="form1">               
                <div align="center">
                    
                    <h:outputText styleClass="outputTextTitulo"  value="Programas de Producción" />                    
                    <br><br>
                    <%--h:outputText styleClass="outputTextTitulo"  value="Estado::" />                    
                    <h:selectOneMenu value="#{ManagedProgramaProduccion.formulaMaestrabean.estadoRegistro.codEstadoRegistro}" styleClass="inputText" 
                                     valueChangeListener="#{ManagedFormulaMaestra.changeEvent}">
                        <f:selectItems value="#{ManagedEstadosReferenciales.estadosReferenciales}"  />
                        <a4j:support event="onchange"  reRender="dataFormula"  />
                    </h:selectOneMenu--%>  
                    <br> <br>
                    <rich:dataTable value="#{ManagedProgramaProduccion.programaProduccionEditarList}" var="data" id="dataFormula" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                                    headerClass="headerClassACliente" >
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"   />
                            
                            
                        </h:column>
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Producto"  />
                            </f:facet>
                            <h:outputText value="#{data.formulaMaestra.componentesProd.nombreProdSemiterminado}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Cantidad del Lote"  />
                            </f:facet>
                            <h:outputText value="#{data.formulaMaestra.cantidadLote}"  />
                        </h:column>     
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Nro. de Lotes a Producir"  />
                            </f:facet>
                            <h:outputText value="#{data.cantidadLote}"  />
                        </h:column> 
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Nro de Lote"  />
                            </f:facet>
                            <h:inputText styleClass="inputText" size="12" value="#{data.codLoteProduccion}"  />
                        </h:column>   
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Fecha Inicio"  />
                            </f:facet>
                            <h:outputText value="#{data.fechaInicio}"  />
                        </h:column>  
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Fecha Final"  />
                            </f:facet>
                            <h:outputText value="#{data.fechaFinal}"  />
                        </h:column>  
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Observaciones"  />
                            </f:facet>
                            <h:outputText value="#{data.observacion}" />
                        </h:column>
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoProgramaProduccion.nombreEstadoProgramaProd}" />
                        </h:column>
                 
                    </rich:dataTable>
                    
                    <br>
                    <h:commandButton value="Guardar"   styleClass="btn"  action="#{ManagedProgramaProduccion.guardarLotes}"/>
                    <h:commandButton value="Cancelar"    styleClass="btn"  action="#{ManagedProgramaProduccion.cancelar}" />
               
               
                </div>
                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedFormulaMaestra.closeConnection}"  />
                
            </a4j:form>
            
        </body>
    </html>
    
</f:view>

