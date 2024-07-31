"""
此文件提供给GUI对数据库数据增删改查的接口。使用pymysql管理
使用者在自己主机跑的时候需要把第十二行中的第二个root改为自己mysql root用户的密码  以及 数据库创建过程在末尾，
不按步骤做跑不起来自己负责，自己去百度。我这里运行顺利。

"""

import pymysql
# import datetime


class DataBase(object):
    def __init__(self, name):
        self.db = pymysql.connect(host="192.168.1.12", user="root", password="123", database="computer_inventory")
        self.cursor = self.db.cursor()
        self.name = name
        # 获得table的字段名，在add函数中需要用到
        sql = f"select COLUMN_NAME from information_schema.COLUMNS where table_name = '{self.name}'"
        self.cursor.execute(sql)
        self.columns = self.cursor.fetchall()
        # 转换为标准格式
        temp = []
        for column in self.columns:
            temp.append(column[0])
        self.columns = tuple(temp)

    # 根据传入的数据，新建一条条目
    def Add(self, entry):
        sql = f"INSERT INTO {self.name} ({','.join(self.columns)}) VALUES {entry}"
        self.cursor.execute(sql)
        self.db.commit()

    # 删掉条目
    def Delete(self, index):
        sql = "DELETE FROM {0} WHERE id={1}".format(self.name, index)
        self.cursor.execute(sql)
        self.db.commit()

    # 修改某一条目
    def Change(self, index, field, entry):
        try:
            entry = int(entry)
            sql = "UPDATE {0} SET {1}={2} WHERE id={3}".format(self.name, field, entry, index)
        except:
            sql = "UPDATE {0} SET {1}='{2}' WHERE id={3}".format(self.name, field, entry, index)

        self.cursor.execute(sql)
        self.db.commit()

    # 查询出所有的条目，组成二维元组返回
    def Search(self, SQL=""):
        sql = "SELECT * FROM {0}".format(self.name)
        if SQL != "":
            self.cursor.execute(SQL)
        else:
            self.cursor.execute(sql)
        self.results = self.cursor.fetchall()
        return self.results

    def Close(self):
        self.db.close()


# 测试这个模块的API
if __name__ == '__main__':
    test = DataBase("盘点管理")
    results = test.Search()
    print(test.columns)
    test.Add((0, "待赋值", "待赋值", 0, "待赋值", 0, "待赋值", 0, "待赋值", "待赋值", "待赋值"))
