<?php
  class Session {
    private $pdo;

    public function connect() {
      $pdoString = "mysql:host=" . APP_HOST . ";dbname=" . APP_DB;
      $pdo = new PDO($pdoString, APP_USERNAME, APP_PASSWORD);
      return $pdo;
    }

    public function _open() {
      $this->pdo = Session::connect();
      if ($this->pdo) {
        return true;
      }
      else {
        return false;
      }
    } // end function _open()

    public function _close() {
      $this->pdo = null;
      return true;
    } // end function _close()

    public function _read($sess_id) {
      if (!$this->pdo) {
        $this->pdo = Session::connect();
      }
      $sql = "select data from sessions where id=:sess_id";
      $statement = $this->pdo->prepare($sql);
      $statement->execute(array(':sess_id' => $sess_id));
      $num = $statement->rowCount();
      if ($num == 1) {
        $row = $statement->fetch(PDO::FETCH_ASSOC);
        $data = $row["data"];
        return $data;
      }
      else {
        return '';  //  return empty string if no data returned
      }
    } // end function _read()

    public function _write($sess_id,$data) {
      $access = time();
      $sql = "select * from sessions where id=:sess_id";
      $statement = $this->pdo->prepare($sql);
      $statement->execute(array(':sess_id' => $sess_id));
      $num = $statement->rowCount();
      if ($num === 0) {
        $sql = "insert into sessions (id, access, data) values ".
          "(:sess_id,:access,:data)";
        $statement2 = $this->pdo->prepare($sql);
        $myArray = array();
        $myArray[':sess_id'] = $sess_id;
        $myArray[':access'] = $access;
        $myArray[':data'] = $data;
        $statement2->execute($myArray);
        if ($statement2 === false) {
          return false;
        }
        else {
          // new data stored
          return true;
        }
      } // end case of inserting new session data
      else {
        $sql = "update sessions set access = :access, " .
          "data = :data where id = :sess_id";
        $statement2 = $this->pdo->prepare($sql);
        $myArray = array();
        $myArray[':sess_id'] = $sess_id;
        $myArray[':access'] = $access;
        $myArray[':data'] = $data;
        $statement2->execute($myArray);
        if ($statement2 === false) {
          return false;
        }
        else {
          // data updated
          return true;
        }
      } // end case of updating existing record
    } // end function _write()

    public function _destroy($sess_id) {
      $sql= "delete from sessions where id=:id";
      $statement = $this->pdo->prepare($sql);
      $statement->execute(array(':id' => $sess_id));
      if ($statement === true) {
        return true;
      }
      else {
        return false;
      }
    } // end function _destroy()

    public function _gc($max) {
      $old = time() - $max;
      $sql = "delete from sessions where access < :old";
      $statement = $this->pdo->prepare($sql);
      $statement->execute(array(':old' => $old));
      if ($statement === true) {
        return true;
      }
      else {
        return false;
      }
    } // end function _gc
  }
  $sess = new Session();
  session_set_save_handler(
    array($sess,'_open'),
    array($sess,'_close'),
    array($sess,'_read'),
    array($sess,'_write'),
    array($sess,'_destroy'),
    array($sess,'_gc')
    );
  register_shutdown_function('session_write_close');
  session_start();
?>