pragma solidity ^0.4.25;

/* 股票
公司有決策單、更新決策單
顧客可以選擇我要買這家的單或看這家的單
一單多少下去分利
*/

//import "./MLPortfolio.sol";

contract Invest /* is MLPortfolio*/{
 
    address[] public usersAddress;
    mapping(address => string) public userName; 
    uint public stock;
    uint public rate;
    uint public stockNum;
    uint256 public _totalSupply = 0; 
    mapping(address => uint256) public balances;  
    mapping(address => mapping(address => uint256)) allowed;
    mapping(address => mapping(uint => uint)) userStock;
    mapping(uint => uint) public stockData;
    mapping(address => uint) public userVersion;
    mapping(address => uint) userNumber;
    mapping(address => mapping(uint => mapping (uint => uint))) public mlrate;
    mapping(address => mapping (uint => mapping (uint => uint))) public mlPlan; //公司、版本、1-10標的
    uint public turnMoney = 0;
    uint public nowstock;
    uint public nowrate;
    uint num;
    
    
    event buyStocklog(address indexed owner, uint stock, uint rate,uint amount);
    event sellStocklog(address indexed owner, uint stock, uint amount);
    event changeStocklog(address indexed owner, uint stockA, uint stockB, uint turnMoney);
    event changePlanlog(address indexed owner, uint old_ver, uint new_ver);
    event logPrice(uint price);
    event logUserStock(address indexed user, uint sotck,uint amount);
    event logPlan(address indexed owner, uint sotck);
    event logRate(address indexed owner,uint sotck, uint rate);
    
    function cashin(address _user, uint _money) public{
        balances[_user] += _money;
        //msg.sender.transfer(_money);
        
    }


    // 取得合約的所有位址
    function returnArray() public view returns(address[]) {
        return usersAddress;
    }
    
    function setUser(address _addr, string _userName) public {
        usersAddress.push(_addr);
        userName[_addr] = _userName;
    }
    
    function getUserStock(address _to, uint _stock) public {
        
        /* for(uint i=1; i <=5; i++){
          nowstock = getPlan(_to,i,userVersion[msg.sender]);
          emit logUserStock(msg.sender,nowstock,userStock[msg.sender][_stock]);
        }*/
        emit logUserStock(_to,_stock,userStock[msg.sender][_stock]);
    }

    function setuserStock(address _user, uint _stock, uint _num) public{
        userStock[_user][_stock] = _num;
    }
    
    function setVersion(address _user, uint _ver) public{
        userVersion[_user] = _ver;
    }

    function setNumber(address _user, uint _num) public{
        userNumber[_user] = _num;
    }

    function setBalance(address _user, uint _num) public{
        balances[_user] = _num;
        //_user.balance -= _num;
        //this.balance += _num;
    }
    
    //顧名思義，就是直接獲取指定賬戶上 Token 的餘額。
    function balanceOf(address _user) public view returns (uint){
       return balances[_user];
    }
    
    function changePlan(address _addr, uint _ver) public{
        
        emit changePlanlog(_addr,userVersion[msg.sender],_ver);
        sellAll(_addr,userVersion[msg.sender]);
        buyAll(_addr,_ver);
        
    }

    
    /*function updateStock(address _addr, string _stockA, string _stockB) public{
        
        sellStock(_addr,_stockA);
        buyStock(_addr,balances[msg.sender],_stockB);
        
        emit changeStocklog(_addr,_stockA,_stockB,turnMoney);
        
    }*/
    
    
    
    //利用這個 function 的賬戶地址作為 msg.sender，減去指定數量的Token（ tokens），
    //在指定賬戶地址（to）加上相應數量的Token（ tokens），最後再以事件Transfer(msg.sender, to, tokens) 以Log記錄發送賬戶地址、指定賬戶地址、Token 數量。
    /*function buyStock(address _to, uint256 _value, string _stock) public {
        require(balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]);
        
        
         for(uint i=1; i <=5; i++){
          if( keccak256(_stock) == keccak256(getPlan(_to,i,userVersion[msg.sender]))){
              num = i;
          }
        }
          nowrate = getRate(_to,num,userVersion[msg.sender]);
          userStock[msg.sender][_stock]=((balances[msg.sender]/100)*nowrate)/StockPrice(_stock);
          turnMoney += (balances[msg.sender]/100)*nowrate;
          balances[msg.sender] = balances[msg.sender] - turnMoney;
          balances[_to] = balances[_to] + turnMoney;
          emit buyStocklog(msg.sender,_stock,StockPrice(_stock),userStock[msg.sender][_stock]);
          
    }*/
    
    /*function buyStock(address _to, uint256 _value, string _stock) public {
        require(balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]);
         
          nowrate = getRate(_to,userNumber[msg.sender],userVersion[msg.sender]);
          userStock[msg.sender][_stock]=((balances[msg.sender]/100)*nowrate)/StockPrice(_stock);
          turnMoney += (balances[msg.sender]/100)*nowrate;
          balances[msg.sender] = balances[msg.sender] - turnMoney;
          balances[_to] = balances[_to] + turnMoney;
          emit buyStocklog(msg.sender,_stock,StockPrice(_stock),userStock[msg.sender][_stock]);
          
    }

    function sellStock (address _to,  string _stock) public returns (bool){
        
        turnMoney= StockPrice(_stock)*userStock[msg.sender][_stock]; //numberxprice
       
        require(balances[_to] >= turnMoney && balances[msg.sender] + turnMoney >= balances[msg.sender]);  // prevent balance underflow & overflow
        balances[msg.sender] = balances[msg.sender] + turnMoney;
        balances[_to] = balances[_to] - turnMoney;
        userStock[msg.sender][_stock]=0;
        
        emit sellStocklog(msg.sender,_stock,userStock[msg.sender][_stock]);
        
        return true;
    }*/
    
    //在指定賬戶地址（to）加上相應數量的Token（ tokens），最後再以事件Transfer(msg.sender, to, tokens) 以Log記錄發送賬戶地址、指定賬戶地址、Token 數量。
    
    function buyStock(address _to, uint256 _stock, uint _price, uint _rate) public {
        
        //require(balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]);
        //balances[_to] = balances[_to] + _value;

          stockNum = ((balances[_to]/100)* _rate)/_price;
          userStock[_to][_stock]= stockNum;
          turnMoney = _price * stockNum;
          emit buyStocklog(_to,_stock,_rate,userStock[_to][_stock]);
          balances[_to] -= turnMoney; //each stock number
         // balances[_to] += turnMoney*(1+(6/1000));
         turnMoney = 0;
         stockNum = 0;
    
    }
    
    
    
    function buyAll(address _to, uint256 _ver) public {
        
        //require(balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]);
        //balances[_to] = balances[_to] + _value;
        
        for(uint i=1; i <=5; i++){
          nowstock = getPlan(_to,i,_ver);
          nowrate = getRate(_to,i,_ver);
          stockNum = ((balances[msg.sender]/100)*nowrate)/stockData[nowstock];
          userStock[msg.sender][nowstock]= stockNum;
          turnMoney += stockData[nowstock]* stockNum;
          emit buyStocklog(msg.sender,nowstock,nowrate,userStock[msg.sender][nowstock]);
        }
        
        // balances[msg.sender] -= turnMoney*(1+(6/1000)); //each stock number
        // balances[_to] += turnMoney*(1+(6/1000));
         turnMoney = 0;
         stockNum = 0;
    
    }
    
     function sellAll(address _addr,uint256 _ver) public {
        
        for(uint i=1; i <=5; i++){
          nowstock = getPlan(_addr,_ver,i);
          nowrate = getRate(_addr,_ver,i);
          balances[msg.sender] = balances[msg.sender] + (stockData[nowstock]*userStock[msg.sender][nowstock]);
          balances[_addr] = balances[_addr] - (stockData[nowstock]*userStock[msg.sender][nowstock]); //each stock number
          emit sellStocklog(msg.sender,nowstock,userStock[msg.sender][nowstock]);
        }
    
    }
    
    function getPlan(address _addr, uint _version, uint _number) public returns (uint){
      
         stock =  mlPlan[_addr][_version][_number];
         
         //emit logPlan(_addr,stock);
         
         return stock;
    
    }
    
    function getRate(address _addr, uint _version, uint _number) public returns (uint){
       
         stock =  mlPlan[_addr][_version][_number];
         rate = mlrate[_addr][_version][_number];
        // emit logRate(_addr,stock,rate);
         return rate;
    
    }
   
    
    //首先將 from 的賬戶地址中減去指定數量的Token（ tokens），然後就使用上面的 allowed 的msg.sender 允許 from 的賬戶地址減去指定數量的Token（ tokens），
    //然後在 to的賬戶地址中加上相應數量的Token（ tokens），最後再以事件Transfer(from, to, tokens) 以Log記錄發送賬戶地址、指定賬戶地址、Token 數量。
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
        require(balances[_from] >= _value && balances[_to] + _value >= balances[_to]);  // prevent balance underflow & overflow
        require(allowed[_from][msg.sender] - _value <= allowed[_from][msg.sender]);  // prevent allowed underflow
        balances[_from] = balances[_from] - _value;
        allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
        balances[_to] = balances[_to] + _value;
        return true;
    }
    
    function setmlPlan(address _addr, uint _version, uint _num, uint _stockName) public { 

            mlPlan[_addr][_version][_num] = _stockName;
    }

    function setmlRate(address _addr, uint _version,uint _num, uint256 _stockRate) public {

            mlrate[_addr][_version][_num] = _stockRate;
    
    }
    
   
    
    
    function setStockData(uint _name, uint _price) public{
        stockData[_name]=_price;
    }
    
   /* function StockPrice (string _name) public returns (uint){
         stockData["台積電"]=100;
         stockData["鴻海"]=80;
         stockData["聯發科"]=70;
         stockData["國巨"]=50;
         stockData["國泰金"]=70;
         stockData["南亞科"]=60;
         stockData["玉山金"]=80;
         stockData["台新金"]=55;
         stockData["奇力新"]=60;
         stockData["友達"]=30;
         stockData["恆大"]=10;
         stockData["統一"]=45;
         stockData["中裕"]=80;
         stockData["上銀"]=30;
         stockData["訊連"]=55;
        
        // emit logPrice(stockData[_name]);
         return stockData[_name];
    }

    function setmlPlan(address _addr, uint _version) public {
        // program, age
        if(_version == 1){
            mlPlan[_addr][_version][1] = "台積電";
            mlPlan[_addr][_version][2] = "鴻海";
            mlPlan[_addr][_version][3] = "聯發科";
            mlPlan[_addr][_version][4] = "國巨";
            mlPlan[_addr][_version][5] = "國泰金";
            mlPlan[_addr][_version][6] = "南亞科";
            mlPlan[_addr][_version][7] = "玉山金";
            mlPlan[_addr][_version][8] = "聯電";
            mlPlan[_addr][_version][9] = "台新金";
            mlPlan[_addr][_version][10] = "奇力新";
        }
        if(_version == 2){
            mlPlan[_addr][_version][1] = "台積電";
            mlPlan[_addr][_version][2] = "友達";
            mlPlan[_addr][_version][3] = "聯發科";
            mlPlan[_addr][_version][4] = "台新金";
            mlPlan[_addr][_version][5] = "恆大";
            mlPlan[_addr][_version][6] = "南亞科";
            mlPlan[_addr][_version][7] = "玉山金";
            mlPlan[_addr][_version][8] = "聯電";
            mlPlan[_addr][_version][9] = "統一";
            mlPlan[_addr][_version][10] = "中裕";
        }
        if(_version == 3){
            mlPlan[_addr][_version][1] = "台積電";
            mlPlan[_addr][_version][2] = "和益";
            mlPlan[_addr][_version][3] = "聯發科";
            mlPlan[_addr][_version][4] = "國巨";
            mlPlan[_addr][_version][5] = "永豐金";
            mlPlan[_addr][_version][6] = "上銀";
            mlPlan[_addr][_version][7] = "玉山金";
            mlPlan[_addr][_version][8] = "聯電";
            mlPlan[_addr][_version][9] = "訊連";
            mlPlan[_addr][_version][10] = "奇力新";
        }
    }
    
     function setmlRate(address _addr, uint _version) public {
        // program, age
        if(_version == 1){
            mlrate[_addr][_version][1] = 20;
            mlrate[_addr][_version][2] = 10;
            mlrate[_addr][_version][3] = 5;
            mlrate[_addr][_version][4] = 1;
            mlrate[_addr][_version][5] = 15;
            mlrate[_addr][_version][6] = 7;
            mlrate[_addr][_version][7] = 2;
            mlrate[_addr][_version][8] = 12;
            mlrate[_addr][_version][9] = 8;
            mlrate[_addr][_version][10] = 10;
        }
        if(_version == 2){
            mlrate[_addr][_version][1] = 15;
            mlrate[_addr][_version][2] = 15;
            mlrate[_addr][_version][3] = 5;
            mlrate[_addr][_version][4] = 1;
            mlrate[_addr][_version][5] = 10;
            mlrate[_addr][_version][6] = 12;
            mlrate[_addr][_version][7] = 2;
            mlrate[_addr][_version][8] = 12;
            mlrate[_addr][_version][9] = 8;
            mlrate[_addr][_version][10] = 10;
        }
        if(_version == 3){
            mlrate[_addr][_version][1] = 15;
            mlrate[_addr][_version][2] = 10;
            mlrate[_addr][_version][3] = 5;
            mlrate[_addr][_version][4] = 11;
            mlrate[_addr][_version][5] = 15;
            mlrate[_addr][_version][6] = 7;
            mlrate[_addr][_version][7] = 2;
            mlrate[_addr][_version][8] = 10;
            mlrate[_addr][_version][9] = 10;
            mlrate[_addr][_version][10] = 5;
        }
    }*/
    
}

