<html>
    <head>
        <style type="text/css">
            .filas{
            
            }
            .columnas{
                width: 50px;  
                border:1px solid red;
            }
            .panel{
                width: 50px;  
                
            }
            
        </style>
        <script>
            function onmouseovercolumn(obj){
                    obj.style.backgroundColor='red';
                    obj.style.cursor='hand';
                   /* obj.style.width='500px';*/
                   obj.firstChild.style.width='200px';
                   obj.firstChild.style.heigth='200px';
                   
                   obj.firstChild.style.
            }
            function onmouseoutcolumn(obj){
                obj.style.backgroundColor='white';
                obj.style.cursor='hand';
                obj.style.width='50px';
                
                 obj.firstChild.style.width='50px';
                 obj.firstChild.style.heigth='50px';
                   
            
            }
            
        </script>
    </head>
    <body>
        <table >
            <tr class="filas">
                <td class="columnas" onmouseover="onmouseovercolumn(this)"  onmouseout="onmouseoutcolumn(this)">
                    <div class="panel">
                         &nbsp;
                    </div>
                    
                   
                </td>
                <td class="columnas" onmouseover="onmouseovercolumn(this)"  onmouseout="onmouseoutcolumn(this)">
                    <div class="panel">
                         &nbsp;
                    </div>
                </td>
                <td class="columnas" onmouseover="onmouseovercolumn(this)"  onmouseout="onmouseoutcolumn(this)">
                    <div class="panel">
                         &nbsp;
                    </div>
                </td>
                <td class="columnas" onmouseover="onmouseovercolumn(this)"  onmouseout="onmouseoutcolumn(this)">
                    <div class="panel">
                         &nbsp;
                    </div>
                </td>
                <td class="columnas" onmouseover="onmouseovercolumn(this)"  onmouseout="onmouseoutcolumn(this)">
                    <div class="panel">
                         &nbsp;
                    </div>
                </td>
                <td class="columnas" onmouseover="onmouseovercolumn(this)"  onmouseout="onmouseoutcolumn(this)">
                    <div class="panel">
                         &nbsp;
                    </div>
                </td>
            </tr>
        </table>
    </body>
</html>
