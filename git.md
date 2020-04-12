# git

- [git](#git)
  - [tag](#tag)
    - [List tags with pattern `v-*`](#list-tags-with-pattern-v)
    - [Add a tag](#add-a-tag)
    - [Delete a tag](#delete-a-tag)
    - [Checkout a tag](#checkout-a-tag)
  - [`git clone`](#git-clone)

## tag

### List tags with pattern `v-*`

    git tag -l 'v-*'

### Add a tag

    git tag tag-name

### Delete a tag

    git tag -d tag-name

### Checkout a tag

    git checkout tag-name

## `git clone`

    --branch <name>, -b <name>
        Instead of pointing the newly created HEAD to the branch pointed to by the cloned repository’s HEAD, point to <name> branch instead. In a non-bare repository, this is the branch that will be checked out. --branch can also take tags and detaches the HEAD at that commit in the resulting repository.    
