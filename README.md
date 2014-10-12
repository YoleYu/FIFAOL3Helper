FIFAOL3Helper
=============

## 申明
  -  该脚本是基于个人兴趣研究，方便学习按键精灵，写作初衷无违背游戏道德之意。本人对使用该脚本的任何行为不服法律责任。
  -  本脚本完全开源，若在其他地方使用，请尊重作者，注明出处。

## 功能列表
  -  根据提供账号自动登陆，账号密码存在本地任意文件夹，安全使用。
  -  支持多账号循环登陆
  -  支持经理人自动比赛
  -  支持经理人排位自动比赛
  -  自动跳过经理人的过场动画
  -  支持自动换人
  -  支持自动续约
  -  支持对以上动作的多开（游戏本身能几开就支持几个instance）

## 注意事项
  -  运行遇到问题，请点击 [这里](http://blog.yole.me/fifaol3helper%E4%BD%BF%E7%94%A8%E6%B3%A8%E6%84%8F%E4%BA%8B%E9%A1%B9/)
  -  去贴吧看看是否有和你一样的问题。

## 使用
  1.  下载并安装 [按键精灵2014](http://www.anjian.com/downloading2014.html)
  2.  打开按键精灵，点击“新建脚本”，选择“空白脚本”，并点击确定。
      ![Alt text](https://raw.githubusercontent.com/YoleYu/FIFAOL3Helper/3227599ba5aa65ddf55e7c84bc8018c44cf7eed0/1.jpg)   

      ![Alt text](https://raw.githubusercontent.com/YoleYu/FIFAOL3Helper/3227599ba5aa65ddf55e7c84bc8018c44cf7eed0/2.jpg)  
      
  3.  点击右边的源文件，并且将[script文件](https://github.com/YoleYu/FIFAOL3Helper/blob/master/script.Q)中全部内容复制到按键精灵编辑器里。  
      ![Alt text](https://raw.githubusercontent.com/YoleYu/FIFAOL3Helper/3227599ba5aa65ddf55e7c84bc8018c44cf7eed0/3.jpg)

  4.  创建一个txt文件，用了存你的账号密码信息。
      -   必须每一行一个账
      -   账号格式必须是 QQ号/密码/大区/注释      
      -   大区编号 1=华东，2=华南，3=西南，4=华北网通
     例如：123456/mima123_/1/这里可以不写东西   
      -   密码中某些特殊字符可能不支持，请尽量使用字母数字的组合
  5.  更改脚本代码中必要的信息
      -   第三行fifaClient，将括号中的路径改为你游戏客户端的路径
      -   第四行sound，将括号中的路径改为本地任意一个能访问的音乐文件的路径，当脚本所有任务结束后，将播放该音乐。   
      -   第五行text, 替换为你在第3步，创建的账号文件的路径。
      -   第9，10行，经理人循环次数，是否需要自动换人
      -   第16行mode，脚本运行模式。   

      下面的图片没更新
      ![Alt text](https://raw.githubusercontent.com/YoleYu/FIFAOL3Helper/images/configSample.jpg)
  6.  按F10启动脚本。

## 注意事项
 1.  本脚本不提供任何后台后台操作功能    
      这意味着脚本运行时不能有其他窗口遮挡游戏界面
      如果需要后台运行，请自行修改代码。TX能检测到后台运行。
 2.  本脚本不提供任何后台后台操作功能    

## 其他
 1. 如果你觉得我的代码对你有帮助，可以拿起你的手机用支付宝扫一扫。
数量不是问题，0.1元表示你有心人，给1元我明天早餐多吃个鸡蛋，给10元我可以冲个会员
      ![Alt text](https://raw.githubusercontent.com/YoleYu/FIFAOL3Helper/images/alipay.jpg)

