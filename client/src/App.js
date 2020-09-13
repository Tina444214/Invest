import React, { Component } from "react";
import { Route, Router } from 'react-router-dom';
import createHistory from 'history/createBrowserHistory';
import getWeb3 from "./getWeb3";



import InvestContract from "./contracts/Invest.json";//第一步引入合約


import "./App.css";

class App extends Component {
  state = { 
    storageValue: 0,
    web3: null, 
    accounts: null, 
    contract: null,
    investContractAddress: InvestContract['networks']['5777']['address'],
    investContractValue: 0,
    showTable: false,
    userName: "",
    userMoney: 0,
    stock :[1239,2469,3277,4322,5429],
    stockPrice:[20,20,10,50,30],
    stockRate: [15,25,5,25,30],
    stocknum: [0,0,0,0,0]
 };



  componentDidMount = async () => {
    try {
      // Get network provider and web3 instance.
      const web3 = await getWeb3(); //第二步創建web3對象

      // 獲取所有用戶
      // Use web3 to get the user's accounts.
      const accounts = await web3.eth.getAccounts();
      //.then(function(data){alert(data[0])})

      // Get the contract instance.
      const networkId = await web3.eth.net.getId(); ////第三步返回當前網路ID

      //第四步，拿到網路對象
      //const deployedNetwork2 = InvestContract.networks[networkId];
    
      //第五步獲取合約實例
      const InvestContractData = InvestContract.networks[networkId];
      const instance = new web3.eth.Contract(
        InvestContract.abi,//ABI
        InvestContractData && InvestContractData.address,//合約地址
      );
      
      // 把web3、accounts和contract設置到狀態變量中
      // 然後運行runExample方法與合約進行交互
      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      this.setState({ 
        web3, 
        accounts, 
        Invest: instance
      }, this.getUserData);

    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
    }
  };
   
  getUserData = async () => {
    const { Invest } = this.state;

    let insuranceData = [];
    let userData = {};
    const allUserList = await Invest.methods.returnArray().call();
    const userList = [...new Set(allUserList)]; 


    for (var i=0; i<userList.length; i++){
      const name = await this.state.Invest.methods.usersName(userList[i]).call();
      const balances = await this.state.Invest.methods.balances(userList[i]).call();
      const Program = await this.state.Invest.methods.userVersion(userList[i]).call();

      userData[userList[i]]={
        "address": userList[i],
        "name": name,
        "money": balances,
        "program": Program,
      }
    }
    insuranceData.push(userData);
  };

  handleNameChange = async (event) => {
    this.setState({ userName: event.target.value });
  };

  handleMoneyChange = async (event) => {
    this.setState({ userMoney: event.target.value });
  };

  AddUserButton = async () => {
    const { accounts, Invest } = this.state; 
    
    alert(this.state.userName);

    await this.Invest.methods.setUser(
        accounts[0],
        this.state.userName,
      ).send({
        from: this.state.accounts[0],
      });
    const nameback = await this.state.Invest.methods.userName(accounts[0]).call();
    alert("User Name:"+ nameback);
    
  }

  testButton = async () => {
    const { accounts, Invest } = this.state;

    await Invest.methods.setVersion(accounts[0],this.state.userMoney).send({ from: accounts[0] }); 
    const balancesback = await Invest.methods.userVersion(accounts[0]).call();

    alert("User Version:"+balancesback);

  }

  balanceButton = async () => {
    const { accounts, Invest } = this.state;

    await Invest.methods.setBalance(accounts[0],this.state.userMoney).send({ from: accounts[0] }); 
    const balancesback = await Invest.methods.balances(accounts[0]).call();
    this.setState({ userMoney: balancesback });
    //alert("User Balance:" + balancesback);

  }

  stockButton = async () => {
    const { accounts, Invest, stock, stocknum, stockRate, stockPrice, userMoney} = this.state;

    let last = 0;
    
    for (let i = 0; i < stock.length; i++) {
      stocknum[i]= Math.round((userMoney*(stockRate[i]/100))/stockPrice[i]);
      last = userMoney-(stocknum[i]*stockPrice[i]);
      this.setState({ userMoney: last });
      await Invest.methods.setuserStock(accounts[0],stock[i],stocknum[i]).send({ from: accounts[0] }); 
    }
    //alert("User Stock Num:" + stocknum[2]);
    //await Invest.methods.setuserStock(accounts[0],stock[2],stocknum[2]).send({ from: accounts[0] }); 
    //const numback = await Invest.methods.userStock(accounts[0],stock[2]).call();
    //alert("User Stock Num:" + stocknum[2]);
  }
  
  selectProgram2 = async() => {
    await this.Invest.methods.setUser(
      this.state.accounts[0],
      this.state.userName,
    ).send({
      from: this.state.accounts[0],
    });

    //const response = await this.Invest.methods.balances(userList[i]).call(); 
    //alert(response);

  }

  runExample = async () => {
    const { accounts, contract } = this.state;// 從state中把accounts和contract解構出來

    // Stores a given value, 5 by default.
    await contract.methods.set(5).send({ from: accounts[0] }); // 調用合約set方法

    // Get the value from the contract to prove it worked.
    const response = await contract.methods.get().call(); // 調用合約get方法

    // Update state with the result.
    this.setState({ storageValue: response });// 把結果設置到狀態變量storageValue中
  };

  showTable= ()=> {
    this.setState({showTable:!this.state.showTable});
  }
  
  getTableRowData = () => {
    const { stock, stocknum, userMoney} = this.state;
    const data = [
      {
        name: '第一期',
        children: [
          { name: [stock[0]], childChildren: [stocknum[0]]},
          { name: [stock[1]], childChildren: [stocknum[1]]},
          { name: [stock[2]], childChildren: [stocknum[2]]},
          { name: [stock[3]], childChildren: [stocknum[3]]},
          { name: [stock[4]], childChildren: [stocknum[4]]},
          { name: ['餘額：'], childChildren: [userMoney]},
        ],
      }/*,
      {
        name: '第二期',
        children: [
          { name: '國泰金', childChildren: ['10'] },
          { name: '南亞科', childChildren: ['70'] },
          { name: '玉山金', childChildren: ['150'] },
          { name: '台新金', childChildren: ['20'] },
          { name: '台新金', childChildren: ['50']},
        ]
      },
      {
        name: ['第三期',],
        children: [
          { name: '友達', childChildren: ['50'] },
          { name: '恆大', childChildren: ['80'] },
          { name: '統一', childChildren: ['120'] },
          { name: '上銀', childChildren: ['30'] },
          { name: '台新金', childChildren: ['50']},
        ],
        name: ['第三期',],
      },*/
    ];
    const rowData = [];
    data.forEach((firstItem, firstIndex) => {
      const firstRowSpan = firstItem.children.reduce((total, curItem) => total + curItem.childChildren.length, 0);
      firstItem.children.forEach((secondItem, secondIndex) => {
        const secondRowSpan = secondItem.childChildren.length;
        secondItem.childChildren.forEach((thirdItem, thirdIndex) => {
          const tdData = [];
          if (secondIndex === 0 && thirdIndex === 0) {
            tdData.push(<td rowSpan={firstRowSpan}>{firstItem.name}</td>)
          }
          if (thirdIndex === 0) {
            tdData.push(<td rowSpan={secondRowSpan}>{secondItem.name}</td>)
          }
          rowData.push((
            <tr key={`row${firstIndex}${secondIndex}${thirdIndex}`}>
              {
                tdData
              }
              <td>{thirdItem}</td>
            </tr>
          ))
        })
      })
    })
    return rowData;
  }
  
  render() {
    //如果wed沒有連線成功，會顯示以下資訊
    if (!this.state.web3) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }

    let table = null;
    if (this.state.showTable) {
      table = (
        <div style={{ padding: '30px' ,width:'500px'}}>
        <table id="customers">
          <thead>
            <tr>
              <th>期數</th>
              <th>股票</th>
              <th>股數</th>
            </tr>
          </thead>
          <tbody>
            {
              this.getTableRowData()
            }
          </tbody>
        </table>
      </div>
      );
    }
//<p>使用者姓名：<input type="text" value={this.userName} onChange={this.handleNameChange} /><br/></p>
    return ( 
      <div><center>
        <h1>智能投資模擬平台</h1>
        <h3>請投資人輸入資料 </h3>  
        <p><font size="3">使用者地址：{this.state.accounts[0]}</font><br/></p>
        <p>投資金額：<input type="number" value={this.state.userMoney} onChange={this.handleMoneyChange} /><br/></p>
        <p><input type="button" onClick={this.balanceButton} value="確認" /></p>
        <form>
        <div> <p>
            投資決策： <select name="Strategy">
            <option value="Association">Association</option>　
            <option value="Pattern">Pattern</option>　
            <option value="SB">SB</option>　
          </select>
          </p></div>
        <div>
        <p><input type="button" onClick={this.stockButton} value="模擬" /></p>
        </div>
      </form> 
      <p><input type="button" onClick={this.showTable} value="Data" /></p>
      {table}
      </center></div>
      
    );
  }
}

export default App;

