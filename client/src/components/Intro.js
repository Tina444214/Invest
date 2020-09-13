import React, { Component } from 'react';
import { withRouter } from 'react-router-dom';

class Intro extends Component {
  render() {
    return (
      <div>
        <h1>年金保險合約介紹</h1>
        <p>此專案為「年金保險合約」的DEMO，底層為區塊鏈和智能合約，並且將年金保險合約的部分撰寫在智能合約中，前端使用Web3.js，將智能合約與網頁前端加上聯繫。</p>
        <p>年金保險過程中會有數個步驟，分別為</p>
        <ol>
          <li>輸入基本資料</li>
          <li>選擇保險方案</li>
          <li>繳交保險費</li>
          <li>領取年金</li>
          <li>年金合約結束</li>
        </ol>
      </div>
    )
  }
}

export default withRouter(Intro);
