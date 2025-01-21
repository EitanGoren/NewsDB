import datetime
import os
import zipfile

import oracledb
from wallet_cred import username, password, wallet_location, wallet_password, dsn, cdir
from flask import Flask, send_file, request, jsonify
import json
import uuid
import xml.etree.ElementTree as ET

app = Flask(__name__)
global response

articles_output_xml_file = "articles_table.xml"
groups_output_xml_file = "groups_table.xml"
wordinfo_output_xml_file = "wordinfo_table.xml"
words_output_xml_file = "words_table.xml"
wordsgroups_output_xml_file = "wordsgroups_table.xml"
phrases_output_xml_file = "phrases_table.xml"

IMPORT_FOLDER = 'uploads'  # Folder to save uploaded files
if not os.path.exists(IMPORT_FOLDER):
    os.makedirs(IMPORT_FOLDER)

EXPORT_FOLDER = 'downloads'  # Folder to save uploaded files
if not os.path.exists(EXPORT_FOLDER):
    os.makedirs(EXPORT_FOLDER)

ZIPS_FOLDER = 'zips'  # Folder to save uploaded files
if not os.path.exists(ZIPS_FOLDER):
    os.makedirs(ZIPS_FOLDER)


@app.route('/check_word_exists', methods=['GET', 'POST'])
def checkWordExists():
    if request.method == 'POST':
        try:
            request_data = request.data
            request_data = json.loads(request_data.decode('utf-8'))
            word_name = request_data['word_name']
            query = f""" SELECT word_id FROM Words WHERE word LIKE '%{word_name}%' FETCH FIRST 1 ROWS ONLY """

            with oracledb.connect(user=username, password=password, dsn=dsn, config_dir=cdir,
                                  wallet_location=wallet_location,
                                  wallet_password=wallet_password) as connection:
                connection.autocommit = True
                with connection.cursor() as cursor:
                    cursor.execute(query)
                    res = cursor.fetchone()
                    if res:
                        result = True
                        print("Success!")
                    else:
                        result = False
            return jsonify({'success': result, 'response': 'Result received successfully!', 'data': res[0]})
        except Exception as e:
            print(e)
            return jsonify({'success': False, 'response': 'Not such word in database!'})
    else:
        # sending data back to your frontend app
        return jsonify({'check_word_exists': response})


@app.route('/get_all_distinct_info_by_art_name', methods=['GET', 'POST'])
def get_all_distinct_info_by_art_name():
    if request.method == 'POST':
        try:
            request_data = request.data
            request_data = json.loads(request_data.decode('utf-8'))
            article_name = request_data['article_name']

            query1 = f""" SELECT DISTINCT w.page
                                         FROM WordInfo w
                                         JOIN Articles a ON w.article_id = a.article_id
                                         WHERE a.article_name = '{article_name}'
                                    """
            query2 = f""" SELECT DISTINCT w.line
                                         FROM WordInfo w
                                         JOIN Articles a ON w.article_id = a.article_id
                                         WHERE a.article_name = '{article_name}'
                                    """
            query3 = f""" SELECT DISTINCT w.place_in_line
                                         FROM WordInfo w
                                         JOIN Articles a ON w.article_id = a.article_id
                                         WHERE a.article_name = '{article_name}'
                                    """
            query4 = f""" SELECT DISTINCT w.length
                                         FROM WordInfo w
                                         JOIN Articles a ON w.article_id = a.article_id
                                         WHERE a.article_name = '{article_name}'
                                    """
            if len(article_name) == 0:
                pass

            with oracledb.connect(user=username, password=password, dsn=dsn, config_dir=cdir,
                                  wallet_location=wallet_location,
                                  wallet_password=wallet_password) as connection:
                connection.autocommit = True
                with connection.cursor() as cursor:
                    cursor.execute(query1)
                    res1 = [t[0] for t in cursor.fetchall()]
                    res1.sort()
                    if not res1:
                        return jsonify({'success': False, 'response': 'Not such article id in database!'})
                    cursor.execute(query2)
                    res2 = [t[0] for t in cursor.fetchall()]
                    res2.sort()
                    if not res2:
                        return jsonify({'success': False, 'response': 'Not such article id in database!'})
                    cursor.execute(query3)
                    res3 = [t[0] for t in cursor.fetchall()]
                    res3.sort()
                    if not res3:
                        return jsonify({'success': False, 'response': 'Not such article id in database!'})
                    cursor.execute(query4)
                    res4 = [t[0] for t in cursor.fetchall()]
                    res4.sort()
                    if res4:
                        result = True
                        print("Success!")
                    else:
                        return jsonify({'success': False, 'response': 'Not such article id in database!'})
            mapy = {
                "article_name": article_name,
                "pages": res1,
                "lines": res2,
                'place_in_line': res3,
                "lengths": res4,
            }
            return jsonify({'success': result, 'response': 'Result received successfully!', 'data': mapy})
        except Exception as e:
            print(e)
            return jsonify({'success': False, 'response': 'Not such article id in database!'})
    else:
        # sending data back to your frontend app
        return jsonify({'check_word_exists': response})


@app.route('/all_articles', methods=['GET'])
def getArticles():
    try:
        all_words = """ SELECT * FROM Articles """
        temp = []
        with oracledb.connect(user=username, password=password, dsn=dsn, config_dir=cdir, wallet_location=wallet_location,
                              wallet_password=wallet_password) as connection:
            connection.autocommit = True
            with connection.cursor() as cursor:
                res = cursor.execute(all_words)
                for r in res:
                    temp.append(r)
                print("Success!")
        return jsonify({'data': temp})
    except Exception as e:
        print(e)


@app.route('/all_phrases', methods=['GET'])
def getPhrases():
    try:
        all_words = """ SELECT * FROM Phrases """
        temp = []
        with oracledb.connect(user=username, password=password, dsn=dsn, config_dir=cdir, wallet_location=wallet_location,
                              wallet_password=wallet_password) as connection:
            connection.autocommit = True
            with connection.cursor() as cursor:
                res = cursor.execute(all_words)
                for r in res:
                    temp.append(r)
                print("Success!")
        return jsonify({'data': temp})
    except Exception as e:
        print(e)


@app.route('/db_statistics', methods=['GET'])
def getStats():
    try:
        stats = """
                   SELECT 
                        a.article_id,
                        a.article_name,
                        COUNT(w.word_id) AS word_count,
                        COUNT(DISTINCT w.Page) AS distinct_page_count,
                        COUNT(DISTINCT w.Line) AS distinct_line_count,
                        SUM(w.Length) AS total_length,
                        AVG(w.Length) AS avg_chars_per_word, 
                        AVG(word_count_per_line.word_count) AS avg_words_per_line
                    FROM 
                        articles a
                    LEFT JOIN 
                        wordinfo w
                    ON 
                        a.article_id = w.article_id
                    LEFT JOIN (
                        SELECT 
                            article_id, 
                            Line, 
                            COUNT(word_id) AS word_count
                        FROM 
                            wordinfo
                        GROUP BY 
                            article_id, Line
                    ) word_count_per_line
                    ON 
                        w.article_id = word_count_per_line.article_id AND 
                        w.Line = word_count_per_line.Line
                    GROUP BY 
                        a.article_id, a.article_name
                """

        temp = []
        with oracledb.connect(user=username, password=password, dsn=dsn, config_dir=cdir, wallet_location=wallet_location,
                              wallet_password=wallet_password) as connection:
            connection.autocommit = True
            with connection.cursor() as cursor:
                statistics = cursor.execute(stats)
                for art in statistics:
                    mapy = {
                        "article_id": str(art[0]),
                        "article_name": str(art[1]),
                        'words_num': str(art[2]),
                        "pages_num": str(art[3]),
                        "lines_num": str(art[4]),
                        "chars_num": str(art[5]),
                        "avg_chars_per_word": str(art[6]),
                        "avg_words_per_line": str(art[7]),
                    }
                    temp.append(mapy)
                print("Success!")
                print(temp)
        return jsonify({'data': temp})
    except Exception as e:
        print(e)


@app.route('/all_group_words', methods=['GET', 'POST'])
def getGroupWords():
    global response
    if request.method == 'POST':
        try:
            request_data = request.data
            request_data = json.loads(request_data.decode('utf-8'))
            group_name = request_data['group_name']
            query = f""" SELECT Word FROM Words INNER JOIN WordsGroups ON Words.word_id=WordsGroups.word_id AND WordsGroups.group_id = (SELECT group_id FROM Groups WHERE group_name='{group_name}') """
            with oracledb.connect(user=username, password=password, dsn=dsn, config_dir=cdir,
                                  wallet_location=wallet_location,
                                  wallet_password=wallet_password) as connection:
                connection.autocommit = True
                with connection.cursor() as cursor:
                    cursor.execute(query)
                    temp = []
                    for r in cursor.fetchall():
                        temp.append(r[0])
            print("Success!")
            return jsonify({'success': True, 'response': 'Group Words received successfully!', 'data': temp})
        except Exception as e:
            print(e)
            return jsonify({'success': False, 'response': 'Not such word in database!'})
    else:
        # sending data back to your frontend app
        return jsonify({'all_group_words': response})


@app.route('/all_groups', methods=['GET'])
def getGroups():
    try:
        query = """ SELECT * FROM Groups """
        temp = []
        with oracledb.connect(user=username, password=password, dsn=dsn, config_dir=cdir, wallet_location=wallet_location,
                              wallet_password=wallet_password) as connection:
            connection.autocommit = True
            with connection.cursor() as cursor:
                res = cursor.execute(query)
                for r in res:
                    temp.append(r)
                print("Success!")
        return jsonify({'data': temp})
    except Exception as e:
        print(e)


@app.route('/search_article', methods=['GET', 'POST'])
def searchArticles():
    global response
    if request.method == 'POST':
        try:
            request_data = request.data
            request_data = json.loads(request_data.decode('utf-8'))
            article_name = request_data['article_name']
            np_name = request_data['np_name']
            date = request_data['date']
            author = request_data['author']
            subject = request_data['subject']
            words = str(request_data['specific_words']).split(',')

            query = f"""
                    SELECT DISTINCT a.*
                        FROM Articles a
                        LEFT JOIN WordInfo wi ON a.article_id = wi.article_id
                        LEFT JOIN Words w ON wi.word_id = w.word_id
                        WHERE 
                            (a.article_name LIKE '{article_name}' OR '{article_name}' IS NULL)
                            AND (a.newspaper LIKE '{np_name}' OR '{np_name}' IS NULL)
                            AND (a.date_published = '{date}' OR '{date}' IS NULL)
                            AND (a.author LIKE '{author}' OR '{author}' IS NULL)
                            AND (a.subject LIKE '{subject}' OR '{subject}' IS NULL)
                            AND (w.word LIKE '{words[0]}' OR '{words[0]}' IS NULL)
                    """
            temp = []
            with oracledb.connect(user=username, password=password, dsn=dsn, config_dir=cdir,
                                  wallet_location=wallet_location,
                                  wallet_password=wallet_password) as connection:
                connection.autocommit = True
                with connection.cursor() as cursor:
                    res = cursor.execute(query)
                    for r in res:
                        temp.append(r)
                    print("Success!")
            return jsonify({'success': True, 'response': 'Articles received successfully!', 'data': temp})
        except Exception as e:
            print(e)
    else:
        # sending data back to your frontend app
        return jsonify({'search_article': response})


@app.route('/insert_article', methods=['GET', 'POST'])
def insertNewArticle():
    global response
    if request.method == 'POST':
        try:
            request_data = request.data
            request_data = json.loads(request_data.decode('utf-8'))
            article_id = uuid.uuid1()
            article_name = str(request_data['article_name']).replace('.txt', '')
            np_name = request_data['np_name']
            _date = str(request_data['date']).split('-')
            year = int(_date[2])
            month = int(_date[1])
            day = int(_date[0])
            author = request_data['author']
            subject = request_data['subject']
            data = request_data['data']

            with oracledb.connect(user=username, password=password, dsn=dsn, config_dir=cdir, wallet_location=wallet_location,
                                  wallet_password=wallet_password) as connection:
                connection.autocommit = True
                with connection.cursor() as cursor:
                    insert_article_query = f""" INSERT INTO Articles VALUES ('{article_id}', '{article_name}', '{np_name}', TO_DATE('{day}/{month}/{year}', 'dd/mm/yyyy'), '{author}', '{subject}') """
                    cursor.execute(insert_article_query)
                    insertNewArticleAux(data, article_id, cursor)

            return jsonify({'success': True, 'response': f'{article_name} Added Successfully!'})
        except Exception as e:
            return jsonify({'success': False, 'response': e})
    else:
        # sending data back to your frontend app
        return jsonify({'insert_article': response})


def insertNewGroupAux(words_ids, group_id, cursor):
    try:
        line_num = 0
        for idx in range(len(words_ids)):
            _ids = str(words_ids[idx]).split(' ')
            if words_ids[idx] == '':
                continue
            line_num += 1
            word_idx = 1
            for word_id in _ids:
                if word_id == '':
                    continue
                word_idx += 1
                insert_group_words_query = f""" INSERT INTO WordsGroups VALUES ('{word_id}', '{group_id}') """
                cursor.execute(insert_group_words_query)
    except Exception as e:
        print(e)


@app.route('/insert_group', methods=['GET', 'POST'])
def defineNewGroup():
    if request.method == 'POST':
        try:
            request_data = request.data
            request_data = json.loads(request_data.decode('utf-8'))
            group_id = uuid.uuid1()
            group_name = request_data['group_name']
            words_ids = request_data['words_ids']

            with oracledb.connect(user=username, password=password, dsn=dsn, config_dir=cdir, wallet_location=wallet_location,
                                  wallet_password=wallet_password) as connection:
                connection.autocommit = True
                with connection.cursor() as cursor:
                    insert_article_query = f""" INSERT INTO Groups VALUES ('{group_id}','{group_name}') """
                    cursor.execute(insert_article_query)
                    insertNewGroupAux(words_ids, group_id, cursor)

            return jsonify({'success': True, 'response': f'{group_name} Added Successfully!'})
        except Exception as e:
            return jsonify({'success': False, 'response': e})
    else:
        # sending data back to your frontend app
        return jsonify({'insert_group': response})


@app.route('/add_words_to_group', methods=['GET', 'POST'])
def addWordsToGroup():
    if request.method == 'POST':
        try:
            request_data = request.data
            request_data = json.loads(request_data.decode('utf-8'))
            group_name = request_data['group_name']
            words = request_data['words_ids']

            with oracledb.connect(user=username, password=password, dsn=dsn, config_dir=cdir, wallet_location=wallet_location,
                                  wallet_password=wallet_password) as connection:
                connection.autocommit = True
                with connection.cursor() as cursor:
                    query = f""" SELECT group_id FROM Groups WHERE group_name='{group_name}' """
                    cursor.execute(query)
                    result = cursor.fetchone()
                    insertNewGroupAux(words, result[0], cursor)
            return jsonify({'success': True, 'response': f'{group_name} Added Successfully!'})
        except Exception as e:
            return jsonify({'success': False, 'response': e})
    else:
        # sending data back to your frontend app
        return jsonify({'insert_group': response})


def insertNewArticleAux(data, article_id, cursor):
    try:
        line_num = 0
        for idx in range(len(data)):
            _words = str(data[idx]).split(' ')
            words = [s.replace("'", "''") for s in _words]
            if data[idx] == '':
                continue
            line_num += 1
            word_idx = 1
            for word in words:
                if word == '':
                    continue
                word_id = uuid.uuid1()
                _article_id = article_id
                word_len = len(word)
                word_page = 1
                word_line = line_num
                place_in_line = word_idx
                word_idx += 1

                check_words_query = f""" SELECT word_id FROM Words WHERE Words.word='{word}' """
                cursor.execute(check_words_query)
                result = cursor.fetchone()
                if result:
                    word_id = str(result[0])
                else:
                    insert_words_query = f""" INSERT INTO Words VALUES ('{word_id}', '{word}') """
                    cursor.execute(insert_words_query)

                insert_word_info_query = f""" INSERT INTO WordInfo VALUES ('{word_id}', '{article_id}', {word_len}, {word_page}, {word_line}, {place_in_line}) """
                cursor.execute(insert_word_info_query)
    except Exception as e:
        print(e)


@app.route('/all_words', methods=['GET'])
def getAllWords():
    try:
        all_words = """ SELECT Words.word, WordInfo.length, WordInfo.page, WordInfo.line, WordInfo.place_in_line FROM WordInfo INNER JOIN Words ON WordInfo.word_id=Words.word_id """
        temp = []
        with oracledb.connect(user=username, password=password, dsn=dsn, config_dir=cdir, wallet_location=wallet_location,
                              wallet_password=wallet_password) as connection:
            connection.autocommit = True
            with connection.cursor() as cursor:
                cursor.execute(all_words)
                res = cursor.fetchall()
                for r in res:
                    temp.append(r)
                print("Success!")
        return jsonify({'words': temp})
    except Exception as e:
        print(e)


@app.route('/all_words_by_params', methods=['GET', 'POST'])
def all_words_by_params():
    if request.method == 'POST':
        request_data = request.data
        request_data = json.loads(request_data.decode('utf-8'))
        article_name = request_data['article_name']
        if request_data['article_name'] == 'All Articles':
            query = f""" SELECT Article_id, Article_name FROM Articles """
        else:
            query = f""" SELECT Article_id, Article_name FROM Articles WHERE Article_name='{article_name}' """

        temp = []
        artIds = []
        with oracledb.connect(user=username, password=password, dsn=dsn, config_dir=cdir,
                              wallet_location=wallet_location,
                              wallet_password=wallet_password) as connection:
            connection.autocommit = True
            with connection.cursor() as cursor:
                query_result = cursor.execute(query)
                for ID in query_result:
                    artIds.append(ID)
                    print("Success!")
            try:
                connection.autocommit = True
                with connection.cursor() as cursor:
                    for _id in artIds:
                        all_words = f""" SELECT Words.word, WordInfo.length, WordInfo.page, WordInfo.line, WordInfo.place_in_line FROM WordInfo INNER JOIN Words ON WordInfo.word_id=Words.word_id WHERE WordInfo.article_id='{_id[0]}' """
                        res = cursor.execute(all_words)
                        for word in res:
                            word = word + (_id[1],)
                            temp.append(word)
            except Exception as e:
                print(e)

            if len(temp) > 0:
                _response = 'All words received!'
            else:
                _response = "Didn't find any match.."

        return jsonify({'success': True, 'response': _response, 'data': temp})
    else:
        # sending data back to your frontend app
        return jsonify({'response': response})


def dropTable(table):
    _dropTableQuery = f""" DROP TABLE {table} """
    with oracledb.connect(user=username, password=password, dsn=dsn, config_dir=cdir, wallet_location=wallet_location,
                          wallet_password=wallet_password) as connection:
        connection.autocommit = True
        with connection.cursor() as cursor:
            temp = []
            cursor.execute(_dropTableQuery)
            print("Success!")
            return temp


@app.route('/drop_article', methods=['GET', 'POST'])
def dropArticle():
    if request.method == 'POST':
        try:
            request_data = request.data
            request_data = json.loads(request_data.decode('utf-8'))
            article_id = request_data['article_id']
            _dropArticleQuery = f""" DELETE FROM Articles WHERE Article_id='{article_id}' """
            _dropWordsQuery = f""" DELETE FROM WordInfo WHERE Article_id='{article_id}' """

            with oracledb.connect(user=username, password=password, dsn=dsn, config_dir=cdir,
                                  wallet_location=wallet_location,
                                  wallet_password=wallet_password) as connection:
                connection.autocommit = True
                with connection.cursor() as cursor:
                    cursor.execute(_dropWordsQuery)
                    print("Success!")
                try:
                    connection.autocommit = True
                    with connection.cursor() as cursor:
                        cursor.execute(_dropArticleQuery)
                        print("Success!")
                except Exception as e:
                    print(e)

            return jsonify({'success': True, 'response': 'Article deleted successfully!'})
        except Exception as e:
            return jsonify({'success': False, 'response': e})
    else:
        return jsonify({'success': False, 'response': 'Failed!'})


def createWordsTable():
    create_table_query = """ CREATE TABLE Words(
        Word_id VARCHAR(255),
        Article_id VARCHAR(255),
        Word VARCHAR(255),
        Length INT,
        Page INT,
        Line INT,
        Place_in_line INT
    ) """

    with oracledb.connect(user=username, password=password, dsn=dsn, config_dir=cdir, wallet_location=wallet_location,
                          wallet_password=wallet_password) as connection:
        connection.autocommit = True
        with connection.cursor() as cursor:
            cursor.execute(create_table_query)


def createArticlesTable():
    create_table_query = """ CREATE TABLE Articles(
        Article_id VARCHAR(255),
        Article_name VARCHAR(255),
        Newspaper VARCHAR(255),
        Date_published INT,
        Author VARCHAR(255),
        Subject VARCHAR(255)
    ) """

    with oracledb.connect(user=username, password=password, dsn=dsn, config_dir=cdir, wallet_location=wallet_location,
                          wallet_password=wallet_password) as connection:
        connection.autocommit = True
        with connection.cursor() as cursor:
            cursor.execute(create_table_query)


def createPhrasesTable():
    create_table_query = """ 
                            CREATE TABLE Phrases(
                                Phrase_id VARCHAR(255),
                                Article_id VARCHAR(255),
                                Phrase VARCHAR(255),
                                Length INT
                            )
                         """

    with oracledb.connect(user=username, password=password, dsn=dsn, config_dir=cdir, wallet_location=wallet_location,
                          wallet_password=wallet_password) as connection:
        connection.autocommit = True
        with connection.cursor() as cursor:
            cursor.execute(create_table_query)


@app.route('/words_by_article_info', methods=['GET', 'POST'])
def words_by_article_info():
    if request.method == 'POST':
        try:
            request_data = request.data
            request_data = json.loads(request_data.decode('utf-8'))
            article_id = request_data['article_id']

            if len(article_id) == 0:
                query = f""" 
                SELECT Page, line, Place_in_line, Length, Article_name 
                FROM WordInfo, Articles
                WHERE WordInfo.article_id = Articles.article_id
                ORDER BY line ASC """
            else:
                ids = '('
                for _id in article_id:
                    ids += "'" + _id + "'" + ','
                ids = ids[:len(ids) - 1] + ')'
                query = f""" 
                SELECT Page, line, Place_in_line, Length, Article_name 
                FROM WordInfo, Articles
                WHERE WordInfo.article_id IN {ids} 
                ORDER BY line ASC """

            pages = []
            lines = []
            placeInLine = []
            lengths = []
            art_names = []

            with oracledb.connect(user=username, password=password, dsn=dsn, config_dir=cdir,
                                  wallet_location=wallet_location,
                                  wallet_password=wallet_password) as connection:
                connection.autocommit = True
                with connection.cursor() as cursor:
                    cursor.execute(query)
                    result = cursor.fetchall()
                    for info in result:
                        pages.append(str(info[0]))
                        lines.append(str(info[1]))
                        placeInLine.append(str(info[2]))
                        lengths.append(str(info[3]))
                        art_names.append(str(info[4]))

            if len(pages) > 0 and len(lines) > 0 and len(placeInLine) > 0 and len(lengths) > 0:
                _response = 'All words received!'
            else:
                _response = "Didn't find any match.."

            return jsonify({'success': True,
                            'response': _response,
                            'pages': pages,
                            'lines': lines,
                            'place_in_line': placeInLine,
                            'lengths': lengths
                            })
        except Exception as e:
            print(e)
            return jsonify({'success': False,
                            'response': str(e),
                            'pages': [],
                            'lines': [],
                            'place_in_line': [],
                            'lengths': [],
                            })
    else:
        # sending data back to your frontend app
        return jsonify({'response': response})


@app.route('/search_words_by_params', methods=['GET', 'POST'])
def search_words_by_params():
    if request.method == 'POST':
        try:
            request_data = request.data
            request_data = json.loads(request_data.decode('utf-8'))
            article_name = request_data['article_name']
            page = request_data['page']
            line = request_data['line']
            place_in_line = request_data['place_in_line']
            length = request_data['length']

            temp = []
            with oracledb.connect(user=username, password=password, dsn=dsn, config_dir=cdir,
                                  wallet_location=wallet_location,
                                  wallet_password=wallet_password) as connection:
                connection.autocommit = True
                with connection.cursor() as cursor:
                    query1 = f"""
                                SELECT a.article_name, wi.page, wi.line, wi.place_in_line, wi.length, w.word
                                FROM Articles a
                                LEFT JOIN WordInfo wi ON a.article_id = wi.article_id
                                LEFT JOIN Words w ON wi.word_id = w.word_id
                                WHERE 
                                    (a.article_name LIKE '{article_name}' OR '{article_name}' IS NULL)
                                    AND (wi.page LIKE '{page}' OR '{page}' IS NULL)
                                    AND (wi.line LIKE '{line}' OR '{line}' IS NULL)
                                    AND (wi.place_in_line LIKE '{place_in_line}' OR '{place_in_line}' IS NULL)
                                    AND (wi.length LIKE '{length}' OR '{length}' IS NULL)
                                ORDER BY Page ASC, Line ASC, Place_in_line ASC
                            """
                    res = cursor.execute(query1)
                    for word in res:
                        word = word + (article_name,)
                        temp.append(word)
                    print("Success!")
            return jsonify({'success': True, 'response': 'words received successfully!!', 'data': temp})
        except Exception as e:
            print(e)
            return jsonify({'success': False, 'response': str(e)})
    else:
        # sending data back to your frontend app
        return jsonify({'search_article': response})


def export_table_to_xml(table_name, xml_file):
    query = f""" SELECT * FROM {table_name} """
    export_oracle_table_to_xml(query, xml_file)
    prettify(xml_file)


def export_oracle_table_to_xml(query, xml_file):
    # Step 1: Establish connection to the Oracle Database
    try:
        with oracledb.connect(user=username, password=password, dsn=dsn, config_dir=cdir,
                              wallet_location=wallet_location,
                              wallet_password=wallet_password) as connection:
            connection.autocommit = True
            with connection.cursor() as cursor:
                cursor.execute(str(query))

                # Step 3: Fetch column names and data rows
                columns = [desc[0] for desc in cursor.description]
                rows = cursor.fetchall()

                # Step 4: Create an XML root element
                root = ET.Element('Root')  # or any name you want for the root tag

                # Step 5: Create XML nodes for each row
                for row in rows:
                    row_elem = ET.SubElement(root, 'Row')
                    for col_name, value in zip(columns, row):
                        col_elem = ET.SubElement(row_elem, col_name)
                        col_elem.text = str(value) if value is not None else 'NULL'

                # Step 6: Convert to an XML string and save to a file
                tree = ET.ElementTree(root)
                tree.write(xml_file, encoding='utf-8', xml_declaration=True)

                print(f"Export completed successfully, XML file saved to {xml_file}")
    except Exception as e:
        print(f"Database error: {e}")


def import_articles_from_xml_to_oracle():
    # Step 1: Establish connection to the Oracle Database
    try:
        with oracledb.connect(user=username, password=password, dsn=dsn, config_dir=cdir,
                              wallet_location=wallet_location,
                              wallet_password=wallet_password) as connection:
            connection.autocommit = True
            with connection.cursor() as cursor:
                # Step 2: Parse the XML file
                tree = ET.parse(f"{IMPORT_FOLDER}/articles_table.xml")
                root = tree.getroot()

                # Step 3: Process each <Row> in the XML file
                for row_elem in root.findall('Row'):
                    # Gather the values of each column from the XML Row
                    column_values = []
                    for col_elem in row_elem:
                        column_values.append(col_elem.text if col_elem.text is not None else None)

                    article_id = column_values[0]
                    article_name = column_values[1]
                    np_name = column_values[2]
                    date = column_values[3]
                    _date = str(date).split(' ')[0].split("-")
                    year = int(_date[0])
                    month = int(_date[1])
                    day = int(_date[2])
                    author = column_values[4]
                    subject = column_values[5]

                    insert_article_query = f""" INSERT INTO Articles VALUES ('{article_id}', '{article_name}', '{np_name}', TO_DATE('{day}/{month}/{year}', 'dd/mm/yyyy'), '{author}', '{subject}') """

                    # Step 5: Execute the INSERT statement
                    cursor.execute(insert_article_query)

                # Step 6: Commit the transaction
                connection.commit()
                print(f"Data successfully imported into Articles.")
    except Exception as e:
        print(f"Error: {e}")


def import_xml_to_oracle(xml_file, table_name):
    # Step 1: Establish connection to the Oracle Database
    try:
        with oracledb.connect(user=username, password=password, dsn=dsn, config_dir=cdir,
                              wallet_location=wallet_location,
                              wallet_password=wallet_password) as connection:
            connection.autocommit = True
            with connection.cursor() as cursor:
                # Step 2: Parse the XML file
                tree = ET.parse(f"{IMPORT_FOLDER}/{xml_file}")
                root = tree.getroot()

                # Step 3: Process each <Row> in the XML file
                for row_elem in root.findall('Row'):
                    # Gather the values of each column from the XML Row
                    column_values = []
                    for col_elem in row_elem:
                        column_values.append(col_elem.text if col_elem.text is not None else None)

                    # Step 4: Create SQL insert statement based on the number of columns
                    placeholders = ', '.join([':{}'.format(i + 1) for i in range(len(column_values))])
                    sql = f""" INSERT INTO {table_name} VALUES ({placeholders}) """

                    # Step 5: Execute the INSERT statement
                    cursor.execute(sql, column_values)

                # Step 6: Commit the transaction
                connection.commit()
                print(f"Data successfully imported into DB.")
    except Exception as e:
        print(f"Error: {e}")


def prettify(xml_file):

    # Parse the XML file
    tree = ET.parse(str(xml_file))
    root = tree.getroot()

    # Define a function to recursively indent elements
    def indent(elem, level=0):
        i = "\n" + "  " * level
        if len(elem):
            if not elem.text or not elem.text.strip():
                elem.text = i + "  "
            if not elem.tail or not elem.tail.strip():
                elem.tail = i
            for child in elem:
                indent(child, level + 1)
            if not elem.tail or not elem.tail.strip():
                elem.tail = i
        else:
            if level and (not elem.tail or not elem.tail.strip()):
                elem.tail = i

    # Apply indentation
    indent(root)

    # Write the formatted XML back to the file
    tree.write(xml_file, encoding="utf-8", xml_declaration=True)


def create_folder_if_not_exists(folder_path):
    try:
        os.makedirs(folder_path, exist_ok=True)
        print(f"Folder '{folder_path}' is ready.")
    except Exception as e:
        print(f"Error creating folder '{folder_path}': {e}")


@app.route('/export_db_to_xml', methods=['GET'])
def exportDbToXml():
    try:
        export_table_to_xml("Articles", f'{EXPORT_FOLDER}/{articles_output_xml_file}')
        export_table_to_xml("Groups", f'{EXPORT_FOLDER}/{groups_output_xml_file}')
        export_table_to_xml("Words", f'{EXPORT_FOLDER}/{words_output_xml_file}')
        export_table_to_xml("WordInfo", f'{EXPORT_FOLDER}/{wordinfo_output_xml_file}')
        export_table_to_xml("WordsGroups", f'{EXPORT_FOLDER}/{wordsgroups_output_xml_file}')
        export_table_to_xml("Phrases", f'{EXPORT_FOLDER}/{phrases_output_xml_file}')

        print("Success!")

        file_path = f'{ZIPS_FOLDER}/output.zip'
        zip_files(file_path)
        data = send_file(file_path, as_attachment=True)

        return data
    except Exception as e:
        print(e)


@app.route('/upload_zip', methods=['POST'])
def upload_zip():
    try:
        # Check if the request contains a file
        if 'file' not in request.files:
            return jsonify({"error": "No file part"}), 400

        file = request.files['file']

        # Check if the file is a valid ZIP file
        if file and file.filename.endswith('.zip'):
            # Save the file to the server
            file_path = os.path.join(ZIPS_FOLDER, file.filename)
            file.save(file_path)

            # Open the ZIP file and extract its contents
            with zipfile.ZipFile(file_path, 'r') as zip_ref:
                zip_ref.extractall(IMPORT_FOLDER)

            import_articles_from_xml_to_oracle()
            import_xml_to_oracle(words_output_xml_file, 'Words')
            import_xml_to_oracle(wordsgroups_output_xml_file, 'WordsGroups')
            import_xml_to_oracle(wordinfo_output_xml_file, 'WordInfo')
            import_xml_to_oracle(phrases_output_xml_file, 'Phrases')
            import_xml_to_oracle(groups_output_xml_file, 'Groups')

            return jsonify({"message": f"File {file.filename} uploaded successfully!"}), 200
        else:
            return jsonify({"error": "Invalid file format. Only ZIP files are allowed."}), 400
    except Exception as e:
        return jsonify({"error": str(e)}), 500


def zip_files(zip_file_path):
    try:
        with zipfile.ZipFile(zip_file_path, 'w', zipfile.ZIP_DEFLATED) as zipf:
            for file in os.listdir(EXPORT_FOLDER):
                zipf.write(f"{EXPORT_FOLDER}/{file}", arcname=os.path.basename(f"xml/{file}"))
                print(f"Added {file} to the zip file.")
        print(f"Zip file created at: {zip_file_path}")
    except Exception as e:
        print(f"Error creating zip file: {e}")


@app.route('/get_phrase_by_starting_word', methods=['GET', 'POST'])
def getPhraseByWordArticleAndNum():
    global response
    if request.method == 'POST':
        try:
            request_data = request.data
            request_data = json.loads(request_data.decode('utf-8'))
            number = request_data['number']
            article_name = request_data['article_name']
            first_word = request_data['first_word']

            query = f"""
                        WITH OrderedWords AS (
                            SELECT 
                                w.word,
                                wi.page,
                                wi.line,
                                wi.place_in_line,
                                ROW_NUMBER() OVER (ORDER BY wi.page, wi.line, wi.place_in_line) AS position
                            FROM 
                                Words w
                            JOIN 
                                WordInfo wi ON w.word_id = wi.word_id
                            JOIN 
                                Articles a ON wi.article_id = a.article_id
                            WHERE 
                                a.article_name = '{article_name}'       
                                AND w.word LIKE CONCAT('{first_word}', '%') 
                        ),
                        ConsecutiveGroups AS (
                            SELECT 
                                ow.word,
                                ow.page,
                                ow.line,
                                ow.place_in_line,
                                ow.position,
                                ow.position - ROW_NUMBER() OVER (PARTITION BY NULL ORDER BY ow.position) AS group_id
                            FROM 
                                OrderedWords ow
                        )
                        SELECT 
                            word
                        FROM 
                            ConsecutiveGroups
                        WHERE 
                            group_id = (SELECT group_id 
                                        FROM ConsecutiveGroups
                                        WHERE word LIKE CONCAT(?, '%') 
                                        LIMIT 1)
                        LIMIT {number}
                """

            with oracledb.connect(user=username, password=password, dsn=dsn, config_dir=cdir,
                                  wallet_location=wallet_location,
                                  wallet_password=wallet_password) as connection:
                connection.autocommit = True
                with connection.cursor() as cursor:
                    cursor.execute(query)
                    res = cursor.fetchall()
                    print(res)

            return jsonify({'success': True, 'response': f'Phrase Fetched Successfully!'})
        except Exception as e:
            return jsonify({'success': False, 'response': e})
    else:
        # sending data back to your frontend app
        return jsonify({'get_phrase_by_starting_word': response})


@app.route('/get_phrase_info', methods=['GET', 'POST'])
def getPhraseInfo():
    global response
    if request.method == 'POST':
        # Step 1: Establish connection to the Oracle Database
        try:
            request_data = request.data
            request_data = json.loads(request_data.decode('utf-8'))
            phrase_id = request_data['phrase_id']
            article_id = request_data['article_id']
            length = request_data['length']
            query = f"""
                    WITH PhraseWords AS (
                        SELECT
                            w.word_id,
                            w.word,
                            wi.page,
                            wi.line,
                            wi.place_in_line,
                            ROW_NUMBER() OVER (ORDER BY wi.page, wi.line, wi.place_in_line) AS position
                        FROM
                            phrases p
                        JOIN
                            words w ON INSTR(',' || REPLACE(LOWER(p.phrase), ' ', ',') || ',', ',' || LOWER(w.word) || ',') > 0
                        JOIN
                            wordinfo wi ON w.word_id = wi.word_id AND wi.article_id = p.article_id
                        WHERE
                            p.phrase_id = '{phrase_id}'
                            AND wi.article_id = '{article_id}'
                    ),
                    ConsecutiveCheck AS (
                        SELECT
                            pw1.word_id,
                            pw1.page,
                            pw1.line,
                            pw1.place_in_line,
                            pw1.position,
                            pw1.position - LAG(pw1.position) OVER (ORDER BY pw1.position) AS position_gap
                        FROM
                            PhraseWords pw1
                    )
                    SELECT
                        page,
                        line,
                        place_in_line
                    FROM
                        ConsecutiveCheck
                    WHERE
                        position_gap IS NULL OR position_gap = 1
                    ORDER BY
                        position
                    """

            with oracledb.connect(user=username, password=password, dsn=dsn, config_dir=cdir,
                                  wallet_location=wallet_location,
                                  wallet_password=wallet_password) as connection:
                connection.autocommit = True
                with connection.cursor() as cursor:
                    cursor.execute(query)
                    result = cursor.fetchall()
                    a = find_consecutive_tuples(result, length)
                    print(a)
                    print('success!')
            return jsonify({'success': True, 'response': 'Phrase info fetched successfully!', 'data': a})
        except Exception as e:
            return jsonify({'success': False, 'response': e})
    else:
        return jsonify({'success': False, 'response': 'Failed!'})


@app.route('/insert_new_phrase', methods=['GET', 'POST'])
def insertNewPhrase():
    global response
    if request.method == 'POST':
        try:
            request_data = request.data
            request_data = json.loads(request_data.decode('utf-8'))
            phrase_id = uuid.uuid1()
            article_id = request_data['article_id']
            length = request_data['length']
            phrase = request_data['phrase']

            with oracledb.connect(user=username, password=password, dsn=dsn, config_dir=cdir,
                                  wallet_location=wallet_location,
                                  wallet_password=wallet_password) as connection:
                connection.autocommit = True
                with connection.cursor() as cursor:
                    query = f""" INSERT INTO Phrases VALUES ('{phrase_id}', '{article_id}', '{phrase}', '{length}') """
                    cursor.execute(query)

            return jsonify({'success': True, 'response': f'{phrase_id} Added Successfully!'})
        except Exception as e:
            return jsonify({'success': False, 'response': e})
    else:
        # sending data back to your frontend app
        return jsonify({'insert_phrase': response})


def find_consecutive_tuples(tuples_list, required_length):
    if not tuples_list or required_length <= 0:
        return []

    # Sort the list by the first, second, and third values
    sorted_tuples = sorted(tuples_list, key=lambda x: (x[0], x[1], x[2]))

    # Iterate over the sorted list to find consecutive tuples
    result = []
    for i in range(len(sorted_tuples)):
        # Initialize the current sequence
        current_sequence = [sorted_tuples[i]]

        for j in range(i + 1, len(sorted_tuples)):
            # Check if the current tuple continues the sequence
            if (sorted_tuples[j][0] == current_sequence[-1][0] and
                    sorted_tuples[j][1] == current_sequence[-1][1] and
                    sorted_tuples[j][2] == current_sequence[-1][2] + 1):
                current_sequence.append(sorted_tuples[j])
            else:
                break  # Sequence is broken

            # If the required length is reached, return the sequence
            if len(current_sequence) == required_length:
                return current_sequence

    # Return an empty list if no matching sequence is found
    return []


if __name__ == '__main__':
    # debug will allow changes without shutting down the server
    app.run(debug=True)
    # createPhrasesTable()
