<template>
  <el-row type="flex" align="middle" class="current-user">
    <div class="icon-title">
      <span>{{ currentUser.name.substring(0, 1) }}</span>
    </div>
    <span class="username">{{ currentUser.name }}</span>
  </el-row>
</template>

<script>
import {getCurrentUser} from "@/common/js/utils";

export default {
    name: "CurrentUser",

    data() {
      return {
        editVisible: false,
        id: "123456",
        squareUrl: "https://cube.elemecdn.com/9/c2/f0ee8a3c7c9638a54940382568c9dpng.png",
        form: {}
      }
    },
    methods: {
      edit() {
        this.editVisible = true;
        this.form = Object.assign({}, this.currentUser);
      },
      submit() {
        this.editVisible = false;
      }
    },
    computed: {
      currentUser: () => {
        return getCurrentUser();
      }
    }
  }
</script>

<style scoped>
  .current-user .username {
    display: inline-block;
    font-size: 16px;
    font-weight: 500;
    margin: 0 5px;
    overflow-x: hidden;
    padding-bottom: 0;
    text-overflow: ellipsis;
    vertical-align: middle;
    white-space: nowrap;
    width: 180px;
  }

  .current-user .edit {
    opacity: 0;
  }

  .current-user:hover .edit {
    opacity: 1;
  }

  .icon-title {
    color: #fff;
    width: 30px;
    background-color: #72dc91;
    height: 30px;
    line-height: 30px;
    text-align: center;
    border-radius: 30px;
    font-size: 14px;
  }
</style>
